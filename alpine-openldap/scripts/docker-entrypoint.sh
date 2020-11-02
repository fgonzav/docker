#!/bin/sh
. ./configuration

SLAPD_CONF="/etc/openldap/slapd.conf"
ORG_CONF="/etc/openldap/org.ldif"
USER_CONF="/etc/openldap/users.ldif"

sed -i "s~{ROOT_USER}~$ROOT_USER~g" "$SLAPD_CONF"
sed -i "s~{SUFFIX}~$SUFFIX~g" "$SLAPD_CONF"
sed -i "s~{ACCESS_CONTROL}~$ACCESS_CONTROL~g" "$SLAPD_CONF"

# encrypt root password before replacing
ROOT_PW=$(slappasswd -s $ROOT_PW)
sed -i "s~{ROOT_PW}~$ROOT_PW~g" "$SLAPD_CONF"

sed -i "s~{SUFFIX}~$SUFFIX~g" "$ORG_CONF"
sed -i "s~{ORGANISATION_NAME}~$ORGANISATION_NAME~g" "$ORG_CONF"

# replace variables in user configuration
sed -i "s~{SUFFIX}~$SUFFIX~g" "$USER_CONF"
sed -i "s~{USER_UID}~$USER_UID~g" "$USER_CONF"
sed -i "s~{USER_GIVEN_NAME}~$USER_GIVEN_NAME~g" "$USER_CONF"
sed -i "s~{USER_SURNAME}~$USER_SURNAME~g" "$USER_CONF"
if [ -z "$USER_PW" ]; then USER_PW="password"; fi
sed -i "s~{USER_PW}~$USER_PW~g" "$USER_CONF"
sed -i "s~{USER_EMAIL}~$USER_EMAIL~g" "$USER_CONF"

# add organisation and users to ldap (order is important)
slapadd -l "$ORG_CONF"
slapadd -l "$USER_CONF"

# add any scripts in ldif
for l in ./ldif/*; do
  case "$l" in
    *.ldif)  echo "ENTRYPOINT: adding $l";
            slapadd -l $l
            ;;
    *)      echo "ENTRYPOINT: ignoring $l" ;;
  esac
done

echo "Starting LDAP"
slapd -d "$LOG_LEVEL" -h "ldap:///"
