# One-liner for setting up a custom OSINT VM from M.Bazzell's book (the link and the linux.sh script belong to M.Bazzell)
# The linux.sh script installs the tools, updates the VM and slightly customises its appearance
# This set-up VM serves as the 'original' machine which is then copied or snapshotted for every new case

wget --user osint10 --password book286xt https://inteltechniques.com/osintbook10/linux.sh && chmod +x linux.sh && ./linux.sh
