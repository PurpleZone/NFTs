#

git user
find . -name '*~1' -delete
jekyll build -d public
git commit -uno -a -m "intention on $(date +%y-%m-%d)"
