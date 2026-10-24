/*
 * Subtitld's launcher on Haiku.
 *
 * Runs Subtitld inside this program instead of starting the interpreter, so
 * the running application is this executable: Deskbar and the rest of the
 * system show its name, icon and signature (its resources, see
 * subtitld.rdef.in), not Python's.
 *
 * - Python is told its executable is the real interpreter (PYTHON), so its
 *   standard library is found as usual and anything that starts
 *   sys.executable gets Python, not Subtitld.
 * - The arguments are Subtitld's, left as they are: sys.argv[0] stays this
 *   program's path, which Qt makes the application's signature from
 *   ("application/x-vnd.qt6-" and the file name), matching the resources.
 * - Neither the current directory (Tracker starts applications in the home
 *   folder) nor this program's own is searched for modules, so no file
 *   there can stand in for one.
 */
#define PY_SSIZE_T_CLEAN
#include <Python.h>

#ifndef PYTHON
#define PYTHON "/boot/system/bin/python3.10"
#endif

static const wchar_t* kRun =
	L"import os, runpy, sys\n"
	L"if sys.path and sys.path[0] in ('', '.', os.path.dirname(sys.argv[0])):\n"
	L"    del sys.path[0]\n"
	L"runpy.run_module('subtitld', run_name='__main__')\n";

int
main(int argc, char** argv)
{
	PyConfig config;
	PyStatus status;

	PyConfig_InitPythonConfig(&config);
	config.parse_argv = 0;
	status = PyConfig_SetBytesString(&config, &config.executable, PYTHON);
	if (!PyStatus_Exception(status))
		status = PyConfig_SetString(&config, &config.run_command, kRun);
	if (!PyStatus_Exception(status))
		status = PyConfig_SetBytesArgv(&config, argc, argv);
	if (!PyStatus_Exception(status))
		status = Py_InitializeFromConfig(&config);
	PyConfig_Clear(&config);
	if (PyStatus_Exception(status))
		Py_ExitStatusException(status);

	return Py_RunMain();
}
