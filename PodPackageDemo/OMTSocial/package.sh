push_podspec_name=OMTSocial.podspec

subspecs=(Core Facebook)

podspec_path=$PWD/$push_podspec_name

# 获取版本号
version=`grep -E "s.version |s.version=" $podspec_path | head -1 | sed 's/'s.version'//g' | sed 's/'='//g'| sed 's/'\"'//g'| sed 's/'\''//g' | sed 's/'[[:space:]]'//g'`


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