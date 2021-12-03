# circleciベースイメージ
FROM cimg/base:stable-20.04

# ファイル権限修正(rootでしかできないため一時的にスイッチ)
USER root
RUN chmod 755 /usr/bin/ssh-agent && \
    chmod 755 /usr/sbin/unix_chkpwd && \
    chmod 755 /usr/lib/policykit-1/polkit-agent-helper-1 && \
    chmod 755 /usr/bin/expiry && \
    chmod 755 /usr/bin/mount && \
    chmod 755 /usr/bin/passwd && \
    chmod 755 /usr/bin/umount && \
    chmod 755 /usr/bin/newgrp && \
    chmod 755 /usr/bin/pkexec && \
    chmod 755 /usr/bin/wall && \
    chmod 755 /usr/bin/crontab && \
    chmod 755 /usr/bin/su && \
    chmod 755 /usr/bin/chsh && \
    chmod 755 /usr/bin/chfn && \
    chmod 755 /usr/bin/sudo && \
    chmod 755 /usr/sbin/pam_extrausers_chkpwd && \
    chmod 755 /usr/lib/openssh/ssh-keysign && \
    chmod 755 /usr/lib/dbus-1.0/dbus-daemon-launch-helper && \
    chmod 755 /usr/bin/chage && \
    chmod 755 /usr/bin/gpasswd

# circleciユーザに再びスイッチ
USER circleci

# healthcheck追加
HEALTHCHECK --interval=5m --timeout=3s CMD echo "test" || exit 1 

# awscliインストール
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install -i /home/circleci/aws-cli -b /home/circleci/.local/bin 

# kubectlインストール
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /home/circleci/kubectl && \
    ln -s /home/circleci/kubectl /home/circleci/.local/bin/kubectl