git push origin master;
git checkout server;
git rebase master;
if [ $? -eq 1 ]; then
    echo "rebase failed";
else
    git push origin server -f;
    echo "rebase succeed";
fi
git checkout master;
