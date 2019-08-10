push_podspec_name=YFSocial.podspec

podspec_path=$PWD/$push_podspec_name

# 获取 podspec 文件版本号
version=`grep -E "s.version |s.version=" $podspec_path | head -1 | grep -o \''[0-9.]*'\' | sed 's/'\''//g'``


subspecs=(Core Facebook)

# 一下代码可以自动匹配所有的 subspecs 并转换为数组
# subspecs=`grep -E "s.subspec" $podspec_path | grep -o \''[a-zA-Z]*'\' | sed 's/'\''//g'`
# subspecs=($subspecs)

for subspec in ${subspecs[@]}
do
  # 打包指令
	subspec="${subspec}" pod package package.podspec --subspecs="${subspec}" --no-mangle --exclude-deps --force  --spec-sources=https://github.com/CocoaPods/Specs.git,https://github.com/Xiaoye220/Specs.git

  # 打包完 commit
  git add .
  git commit -m "package ${subspec}"
done


git push origin master

git tag -d $version
git push origin :refs/tags/$version

git tag -a $version -m $version
git push origin --tags
pod cache clean --all

pod repo push Specs "${push_podspec_name}" --use-libraries --allow-warnings --verbose --sources=https://github.com/CocoaPods/Specs.git,https://github.com/Xiaoye220/Specs.git 