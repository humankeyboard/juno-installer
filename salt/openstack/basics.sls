ntp_setup:
  salt.state:
    - tgt: '*'
    - sls: ntp.install