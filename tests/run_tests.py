import subprocess
import sys


def run(cmd):
    print('Running:', ' '.join(cmd))
    result = subprocess.run(cmd)
    if result.returncode != 0:
        print('Godot exited with', result.returncode)
        sys.exit(result.returncode)

# Start editor in headless mode to avoid import errors
run(['godot', '-e', '--headless', '--quit-after', '2'])

# Run tests
run(['godot', '--headless', '-s', 'tests/test_grader.gd'])
run(['godot', '--headless', '-s', 'tests/test_embeddings.gd'])

print('All tests passed')
