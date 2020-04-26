[ca]
default_ca = CA_default

[CA_default]
new_certs_dir = {{new_certs_dir}}
database = {{database_file}}
serial   = {{serial_file}}

private_key = {{private_key}}
certificate = {{certificate}}

policy = policy_catapult

[policy_catapult]
commonName              = supplied

[req]
prompt = no
distinguished_name = dn

[dn]
CN = {{name}}-account
