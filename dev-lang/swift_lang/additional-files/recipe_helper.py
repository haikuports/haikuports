import json
import urllib.request

from pathlib import Path

script_dir = Path(__file__).resolve().parent

# How to use
#
# 1. Point the target version's Swift source checkout root
#    This script uses the update-checkout-config.json file in the Swift source tree
#    as a Single-Source-Of-Truth of github module dependency.
SWIFT_SOURCE_ROOT = script_dir / '../work-5.9/sources/swift'
# 2. Change the following release/tag name related update-checkout-config.json
#    to the version of Swift to build.
RELEASE_NAME_IN_CONFIG = 'release/5.9'
SWIFT_RELEASE_TAG_NAME = 'swift-5.9-RELEASE'
# 3. Run `python3 path/to/recipe_helper.py`
# 4. Block unused or unsupported dependency if it breaks the build.
BLOCKLIST = [
	# not used (use haiku pkg), strange release
	'cmake', 'icu', 'ninja',
	# not yet supported?
	'swift-atomics', 'swift-nio-ssl', 'swift-docc-render-artifact', 'swift-installer-scripts',
	'swift-integration-tests', 'swift-llvm-bindings', 'swift-numerics', 'swift-xcode-playground-support',
]
# 5. Update SHA256 checksums if you changed the versions to build.
SHA256 = {
	'apple/indexstore-db': '358399fb0f9ecfb75ef83c41cc95756e529d65c867ed445882d5e9f4727aa4df',
	'apple/llvm-project': '9e154e57b790b09f7b4e2673f547795a253c3f58016b64b3d193a651d385d836',
	'apple/sourcekit-lsp': 'af9aa50667db44aa4267d6cfd9b93ce5667d4e7f6400a2f5f3a638084d760f69',
	'apple/swift': 'b94c27a1b1a486b9a1a5c391d466de196a905724a854431b18090c4d5e634ff3',
	'apple/swift-cmark': '220849e92440ba3c106736d19e2ea6e2bd92f26a961493c081f7621b03d5a5e1',
	'apple/swift-corelibs-foundation': 'e8ee140549083ec55abdc97ebc5daa5ffece0e513cb544e1c0bbfcc299941b2d',
	'apple/swift-corelibs-libdispatch': 'c978b1b160a47334311734012c6e68f0b1031428dcb9f0d1457a6dd08bbb644a',
	'apple/swift-corelibs-xctest': '6c628aa295a5b9fd3f03e2f85f5ae19848f68bbe208496b10b7359a0ef6fa243',
	'apple/swift-docc': 'e5cd5d087eedf98c30a0e3cc3f67da63afcff32ef4e9a9f4db36be8294a6461e',
	'apple/swift-docc-symbolkit': '74d5f3427ea95632fb820ff81e24332f5832ebfd48d2985406affcaf3691871f',
	'apple/swift-driver': 'f6814a05fb2464768a7a3d8d7b9d109de076cb83e1920a95bbb67b25e270e5e1',
	'apple/swift-experimental-string-processing': 'e6ab99f405a07acae91fa13f5671f9858671d271faac4a7995757e883bdc0cee',
	'apple/swift-format': '5ab552ec8cc594bfaa379c67f2df1996888ae5a3af6448e102ea240e75687a24',
	'apple/swift-llbuild': '3487305dc724c957c68dfa833e91dec9cf72f6231ea53478b0c78826d0c01835',
	'apple/swift-lmdb': '48043a374d9b6b901c56b80e01be9be065f24aa784e8ff7441c54003955052f2',
	'apple/swift-markdown': '81fe9eb712a0880e706c83166b220399d9a76a0f75a808191c8dda5f5b2ddc70',
	'apple/swift-package-manager': '34bbc9bf16ffc7b6daa18f42c8cb7fd5a7ed8f6639717361fbcc8abe461a3b64',
	'apple/swift-stress-tester': 'ce29e8b9b60199a9e17abf90ab04de629d69dc5fc49fa3ba97f9599aede8da99',
	'apple/swift-syntax': '86a892b980566a22d36a8214adb1cd1936525ebd87c726d02b0f10b30dad4810',
	'apple/swift-tools-support-core': '6873f47ab1d05f732526b76fd46ba9230eedf9f92743919f017a031b81edd14c',
	'apple/swift-argument-parser': '8efd2e7b887d430a6991200ee7b5b1838fb6b594fad1a626915b4dcd3e798816',
	'apple/swift-asn1': '379869dcc7fe0f2a7bb27f1c7ea4fa253edf9ca52ededa8739f1e114a4a0f49b',
	'apple/swift-certificates': 'e2c72c81f405e850c6d85c7c8399a16f97b92db9963bbaa37e7e012c5fd1aed3',
	'apple/swift-collections': '39c7fd6c336579de57b0f9aaf9c6600205f4c1456017293c1fe63ad0f04ca888',
	'apple/swift-crypto': '1074ee5c25f99e704e14139cb132cfcbcb5834ef598b978070be60057f2dc7c0',
	'apple/swift-nio': 'ad7dfe035f6b1a019ff3f5a0beb896f3284d2cc0dbe60905bb8ef7a62d4a9535',
	'apple/swift-system': '8594cd0d701240b140941034a8fd7ca438ddc7ed01c59bc2bd26db5de8e58da4',
	'jpsim/Yams': '8b85c226bf7db141a853abae576a4966d2b82d0180f63d3da5d91988beac9bf1',
}

def main():
	config_items = []
	update_checkout_config_json = SWIFT_SOURCE_ROOT / 'utils/update_checkout/update-checkout-config.json' 
	with open(update_checkout_config_json) as json_file:
		checkout_config = json.load(json_file)
		gh_repos = checkout_config['repos']
		target_branch = checkout_config['branch-schemes'][RELEASE_NAME_IN_CONFIG]['repos']
		for (repoid, tag) in target_branch.items():
			owner_repo = gh_repos[repoid]['remote']['id']
			if tag.ends_with(RELEASE_NAME_IN_CONFIG):
				tag = SWIFT_RELEASE_TAG_NAME
			config_items.append(ConfigItem(repoid, owner_repo, tag))

	# cache to avoid rate limit
	# https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2026-03-10#primary-rate-limit-for-unauthenticated-users
	# > The primary rate limit for unauthenticated requests is 60 requests per hour.
	# https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2026-03-10#about-secondary-rate-limits
	# > - Make too many requests per minute. No more than 90 seconds of CPU time per 60 seconds of real time is allowed.
	# > - Make too many requests to a single endpoint per minute. No more than 900 points per minute are allowed for REST API endpoints, and no more than 2,000 points per minute are allowed for the GraphQL API endpoint.
	ghapi_cache = {}
	cache_modified = False
	cache_json_path = script_dir / 'ghapi_cache.json'
	with open(cache_json_path) as json_file:
		ghapi_cache = json.load(json_file)
	try:
		for item in config_items:
			if item.repoid in BLOCKLIST:
				continue
			tag_url = item.tag_url()
			if tag_url not in ghapi_cache:
				print(f'Fetching tag info for {tag_url}')
				with urllib.request.urlopen(tag_url) as g:
					tag_info = json.load(g)
					ghapi_cache[tag_url] = tag_info
					cache_modified = True
	finally:
		if cache_modified:
			with open(cache_json_path, 'w') as json_file:
				json.dump(ghapi_cache, json_file, indent=2)

	print('# Source URLs')
	n = 1
	for item in config_items:
		if item.repoid in BLOCKLIST:
			continue
		print(item.source_lines(ghapi_cache, n))
		n += 1
	
	print('# Prepare source directories')
	repoids = map(lambda x: x.repoid, config_items)
	repoids = list(filter(lambda x: x not in BLOCKLIST, repoids))
	chunk_size = 4
	chunks = [repoids[i:i + chunk_size] for i in range(0, len(repoids), chunk_size)]
	for i, chunk in enumerate(chunks):
		cmd = ' ' * 9
		if i == 0:
			cmd = 'mkdir -p '
		line = ' '.join(chunk)
		print(f'{cmd}{line} \\')

	print('# Place source files to required layout')
	n = 1
	for item in config_items:
		if item.repoid in BLOCKLIST:
			continue
		print(item.build_line(n))
		n += 1


class ConfigItem:
	def __init__(self, repoid, owner_repo, tag):
		self.repoid = repoid
		self.__owner_repo = owner_repo
		self.__tag = tag
		pass
	
	def tag_url(self):
		git_ref = f'tags/{self.__tag}'
		return f'https://api.github.com/repos/{self.__owner_repo}/git/ref/{git_ref}'
	
	def source_lines(self, tag_infos, n):
		_n = f'_{n}'
		if n == 1:
			_n = ''
		checksum = 'todo'
		if self.__owner_repo in SHA256:
			checksum = SHA256[self.__owner_repo]
		commit = tag_infos[self.tag_url()]['object']['sha']
		tgz_prefix = self.__owner_repo.split('/')[1]
		return f'''\
srcGitRev{_n}="{commit}"
SOURCE_URI{_n}="https://github.com/{self.__owner_repo}/archive/$srcGitRev{_n}.tar.gz"
CHECKSUM_SHA256{_n}="{checksum}"
SOURCE_DIR{_n}="{tgz_prefix}-$srcGitRev{_n}"'''

	def build_line(self, n):
		if n == 1:
			n = ''
		return f'cp -rd $sourceDir{n}/* {self.repoid}'


if __name__ == '__main__':
	main()
