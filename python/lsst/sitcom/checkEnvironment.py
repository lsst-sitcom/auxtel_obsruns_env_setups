import os
from subprocess import getoutput
from pathlib import Path

def testEnvironment(bash_script, installed_packages_directory='~'):
    # First, get the eups environment
    eupsOutput = getoutput('eups list -s')

    # Next, get what it is supposed to be
    rightEnvironment = {}
    # Read the lsst_distrib from the script
    installed_packages_directory = os.path.expanduser(installed_packages_directory)
    script_dir = Path.cwd() / 'bash/lsst/sitcom'
    #scriptName = os.path.join(script_dir, bash_script)
    scriptName = script_dir / bash_script
    # Verify file exists
    if scriptName.exists():
        print(f'Using script {scriptName} for environment verification')
    else:
        raise IOError(f'File {bash_script} not found in {script_dir}')
    
    eupsPkg = getoutput('grep LSST_DISTRIB_VER\= %s'%scriptName)
    lsstPkg = eupsPkg.split("'")[-2]
    rightEnvironment['lsst_distrib'] = lsstPkg
    # Now read the directories from the auto-op-packages directory
    autoDir = os.path.join(installed_packages_directory, 'auto-op-env-packages')
    dirList = os.listdir(autoDir)
    for pkgDir in dirList:
        if pkgDir.split('.')[-1] == 'sh': # Remove the script generated by .user_setups
            continue
        else:
            rightEnvironment[pkgDir] = 'auto-op-env-packages/' + pkgDir

    #Now check if it matches the eups environment
    correct = []
    for pkgName in rightEnvironment.keys():
        foundPkg = False
        if pkgName in ['Spectractor']: # These are not part of the LSST environment
            print(f"{pkgName} is present.")
            foundPkg = True
            continue
        for line in eupsOutput.split('\n'):
            items = line.split(' ')
            if items[0] == pkgName:
                if pkgName == 'lsst_distrib':
                    if rightEnvironment[pkgName] == items[-2]:
                        correct.append(True)
                        print(f"{pkgName} is correct.")
                    else:
                        correct.append(False)
                        print(f"{pkgName} is wrong!  Should be {rightEnvironment[pkgName]}, but yours is {location}")
                    foundPkg = True
                else:
                    try:
                        location = items[-2].split('/')[-2] + '/' + items[-2].split('/')[-1]
                    except:
                        location = items[-2]
                    if rightEnvironment[pkgName] == location:
                        correct.append(True)
                        print(f"{pkgName} is correct.")
                    else:
                        correct.append(False)
                        print(f"{pkgName} is wrong!  Should be {rightEnvironment[pkgName]}, but yours is {location}")
                    foundPkg = True
        if not foundPkg:
            print(f"{pkgName} not found!")
            correct.append(False)

    if all(correct):
        print("Your environment is good!")
    else:
        print("Your environment is not correct!")
    return

