import subprocess
import sys

cmd = ['godot', '--headless', '-s', 'tests/test_grader.gd']
print('Running:', ' '.join(cmd))
result = subprocess.run(cmd)
print('Godot exited with', result.returncode)
sys.exit(result.returncode)
