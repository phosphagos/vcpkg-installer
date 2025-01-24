# check if vcpkg is installed
if [ ! -z "$VCPKG_ROOT" ]; then
    echo "vcpkg installation found at $VCPKG_ROOT."
    echo "please remove the installation,"\
         "and clear environment variable of VCPKG_ROOT"\
         "before start installation"
    exit 1
fi

# check necessary packages installed
# curl, zip, unzip, tar, and git
curl_path=$(command -v curl)
zip_path=$(command -v zip)
unzip_path=$(command -v unzip)
tar_path=$(command -v tar)
git_path=$(command -v git)

if [ -z "$curl_path" \
     -o -z "$zip_path" \
     -o -z "$unzip_path" \
     -o -z "$tar_path" \
     -o -z "$git_path" \
]; then
    echo "required package not installed, aborted."
    echo "please install following packages on your system,"\
         "or contact your system administor for help:"
    echo "    curl zip unzip tar git"
    exit 1
else
    echo "found curl at" "$curl_path"
    echo "fount zip at" "$zip_path"
    echo "found unzip at" "$unzip_path"
    echo "found tar at" "$tar_path"
    echo "found git at" "$git_path"
fi

# read install path
default_path=$HOME/.vcpkg
echo "in which location will install vcpkg at? [ $default_path ]"
read install_path
if [ -z "$install_path" ]; then
    install_path="$default_path"
fi

# start installing
echo "installing vcpkg to $install_path."
set -e

## create dirs if path not exists
if [ ! -d "$install_path" ]; then
    echo "$install_path not exists, created automatically."
    mkdir -p "$install_path"
elif [ ! -z "$(ls -A "$install_path")" ]; then
    echo "$install_path not empty, please clear or remove it before vcpkg installed there."
    exit 1
fi

## chdir to install_dir and start concrete installing
source_path=$PWD
cd "$install_path"

### generating args for bootstrap-vcpkg
bootstrap_args=""

read -r -p "Disable metrics? [y/N] " disable_metrics
case "$disable_metrics" in
    [yY][eE][sS]|[yY]) 
        bootstrap_args+=" -disableMetrics"
        ;;
esac

read -r -p "Use musl instead of glibc? [y/N] " use_musl
case "$use_musl" in
    [yY][eE][sS]|[yY]) 
        bootstrap_args+=" -musl"
        ;;
esac

### cloning and installing vcpkg
git clone https://github.com/Microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.sh $bootstrap_args

### create directories and add utils and tools into it
mkdir bin etc

#### link vcpkg to `bin` directory
ln vcpkg/vcpkg bin/vcpkg

#### add utilities to `bin` directory
cp "$source_path/vcpkg-update.sh" bin/vcpkg-update
chmod +x bin/vcpkg-update

#### add default vcpkg.json to `etc` directory
cp $source_path/vcpkg.json etc/vcpkg.json

### add environment variable declarations to profile file

#### find proper profile file, use bashrc directly currently
profile_path="$HOME/.bashrc"

#### request for permission
read -r -p "Add environment variables to $profile_path? [Y/n] " set_envvars
case "$set_envvars" in
    [nN][oO]|[nN]) 
        exit 1
        ;;
    *)
esac

#### add VCPKG_ROOT
echo "# added by vcpkg-installer" >> "$profile_path"

vcpkg_root="$install_path/vcpkg"
echo "export VCPKG_ROOT=\"$vcpkg_root\"" >> "$profile_path"

#### add CMAKE_TOOLCHAIN_FILE
cmake_toolchain_file="\$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
echo "export CMAKE_TOOLCHAIN_FILE=\"$cmake_toolchain_file\"" >> "$profile_path"

#### add PATH
appended_path="$install_path/bin"
echo "export PATH=\"\$PATH:$appended_path\"" >> "$profile_path"

cd "$source_path"
