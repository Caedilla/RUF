if [ "$1" == "classic" ]
then
  echo "Package and Release for Classic"
  curl -s https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh| bash -s -- -p 283389 -g 1.13.5 -o -m classic.pkgmeta
elif [ "$1" == "live" ]
then
  echo "Package and Release for Retail"
  curl -s https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh| bash -s -- -p 283389 -g 8.3.7 -o -m live.pkgmeta
else
  echo "Game Type not specified."
fi