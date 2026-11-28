import json
import urllib.request

from pathlib import Path

script_dir = Path(__file__).resolve().parent

# How to use
#
# 1. Point the target version's Swift source checkout root
#    This script uses the update-checkout-config.json file in the Swift source tree
#    as a Single-Source-Of-Truth of github module dependency.
SWIFT_SOURCE_ROOT = Path('/boot/home/src/swift-build/swift-haiku-build/swift').resolve() #script_dir / '../work-5.9/sources/swift'
# 2. Change the following release/tag name related update-checkout-config.json
#    to the version of Swift to build.
RELEASE_NAME_IN_CONFIG = 'release/5.10'
SWIFT_RELEASE_TAG_NAME = 'swift-5.10.1-RELEASE'
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
	'apple/llvm-project': 'de3ac94e93fb4cea9b95212b773e3fd09bf6e702d7a2dab884b089a7a617f658',
	'apple/sourcekit-lsp': 'ae4cc80ad4a3f83334a1e7894a2d3216ee8d6ea18f53fd9939f1162a8466d12f',
	'apple/swift': '004d639f0f0d16cdc866f8599efc986bdec01a91b1cf31a06aacb941bf67633d',
	'apple/swift-cmark': 'c899b76929800af4f3eb4e9ddbcd7bca032e736149e2b22c0f94a4a9466f0696',
	'apple/swift-corelibs-foundation': '4b144a35a401d042f711a8e1dd888512ab2363d626869973c2a0a5f14d2e059f',
	'apple/swift-corelibs-libdispatch': '21343f1034b25cefc7a7e9af08189a0863ae466cf77c3c274736be1c8dfde657',
	'apple/swift-corelibs-xctest': '07f9ca8214f51a81e2a78463bde179d990c6ad47b8ea34907d317638f34a4860',
	'apple/swift-docc': '8d71a7cbec7785347751d08dd85a3b8be2485dd4717c0e4ffdb6c96facf906eb',
	'apple/swift-docc-symbolkit': '600c13f09328d20bc4623f1ab2bdea53fd0d1a68b1b5ea6bf0521bf19d071b7e',
	'apple/swift-driver': '505c8146a01b2d0f07bd4be6c3f7fc4139e013a9dc90c63d4d52509d480cdc85',
	'apple/swift-experimental-string-processing': '2093c54878d6532740e684c82c64277bcae9da759b640458ec6b1eaf6196edaa',
	'apple/swift-format': 'fbd36184a549edb94b932ac88f707e89c23956c65e2960db58665cdaa188ddcc',
	'apple/swift-llbuild': '3dd5c5637d345b48f6050bc1850b15dcbe892c142ee00dca6909876ef40f20cb',
	'apple/swift-lmdb': '48043a374d9b6b901c56b80e01be9be065f24aa784e8ff7441c54003955052f2',
	'apple/swift-markdown': 'a6af867d6dc5dce116da4982639292b8bbbf873bbb4203f08195d11d0329b5e9',
	'apple/swift-package-manager': '2a0b97f861e6e2a459f60ae2a948e79722a8737e3f5eb90c478187d6ebab1da4',
	'apple/swift-stress-tester': '59952334c2299a56ab39c54b0d6ad3bdac5a5c17293344f26619623068c83a64',
	'apple/swift-syntax': '9be23f477eaf490f50300c6b73498ed4ea2d71bc981735b79e3823eea6e500aa',
	'apple/swift-tools-support-core': '78f8a0d2a0973511ff4b2afe5ccde63a80bac1fc951752d0c29ba12ba7584f0b',
	'apple/swift-argument-parser': '0d743740f5c3334d341e7ab21d84743fb6eb29f0c8d1714cc2660e37c6dafa29',
	'apple/swift-asn1': 'ef64dfd704ffb2647daa5593c01e255353580227254a2573aa3343164253a648',
	'apple/swift-certificates': '99b9851e8fea9ddba059ce038c42c586f7b5420a835c56d923aa863e5305cadc',
	'apple/swift-collections': 'e585af81e01cbe76e34ede84c3bd8c59324e88bf082656aaba6b3941c1d90722',
	'apple/swift-crypto': '2d87a855b0b6f40cef11613da692aa36697646803dd9b25366cce9eddd879d71',
	'apple/swift-nio': 'ad7dfe035f6b1a019ff3f5a0beb896f3284d2cc0dbe60905bb8ef7a62d4a9535',
	'apple/swift-system': '8594cd0d701240b140941034a8fd7ca438ddc7ed01c59bc2bd26db5de8e58da4',
	'jpsim/Yams': '8b85c226bf7db141a853abae576a4966d2b82d0180f63d3da5d91988beac9bf1',
	'curl/curl': 'b973b0a860c85c7832570c0fb938eb63d31c6c7450925b80ac25b44efa521526',
	'gnome/libxml2': 'cf2753336207666ed850ba606da4a3eb5f0aad955fa8d225dbb9506316b25319',
	'madler/zlib': '261f21433160bf1a78770d628c7548afd0e04c0cfaa7c1b2fb30d28aa8c408a3',
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
			if tag.endswith(RELEASE_NAME_IN_CONFIG):
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
