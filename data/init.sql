/*********************************************************************
* Copyright (c) Intel Corporation 2020
* SPDX-License-Identifier: Apache-2.0
**********************************************************************/
CREATE EXTENSION IF NOT EXISTS citext;
CREATE TABLE IF NOT EXISTS ciraconfigs(
      cira_config_name citext NOT NULL,
      mps_server_address varchar(256),
      mps_port integer,
      user_name varchar(40),
      password varchar(63),
      common_name varchar(256),
      server_address_format integer, 
      auth_method integer, 
      mps_root_certificate text, 
      proxydetails text,
      CONSTRAINT configname UNIQUE(cira_config_name)
    );
CREATE TABLE IF NOT EXISTS wirelessconfigs(
      wireless_profile_name citext NOT NULL,
      authentication_method integer,
      encryption_method integer,
      ssid varchar(32),
      psk_value integer,
      psk_passphrase varchar(63),
      link_policy int[],
      creation_date timestamp,
      created_by varchar(40),
      CONSTRAINT wirelessprofilename UNIQUE(wireless_profile_name)
    );
CREATE TABLE IF NOT EXISTS profiles(
      profile_name citext NOT NULL,
      activation varchar(20) NOT NULL,
      amt_password varchar(40),
      cira_config_name citext REFERENCES ciraconfigs(cira_config_name),
      creation_date timestamp,
      created_by varchar(40),
      mebx_password varchar(40),
      tags text[],
      dhcp_enabled BOOLEAN,
      CONSTRAINT name UNIQUE(profile_name)
    );
CREATE TABLE IF NOT EXISTS profiles_wirelessconfigs(
      wireless_profile_name citext REFERENCES wirelessconfigs(wireless_profile_name),
      profile_name citext REFERENCES profiles(profile_name),
      priority integer,
      creation_date timestamp,
      created_by varchar(40),
      CONSTRAINT wirelessprofilepriority UNIQUE(wireless_profile_name, profile_name, priority)
    );
CREATE TABLE IF NOT EXISTS domains(
      name citext NOT NULL,
      domain_suffix citext NOT NULL,
      provisioning_cert text,
      provisioning_cert_storage_format varchar(40),
      provisioning_cert_key text,
      creation_date timestamp,
      created_by varchar(40),
      CONSTRAINT domainname UNIQUE(name),
      CONSTRAINT domainsuffix UNIQUE(domain_suffix)
    );

CREATE UNIQUE INDEX lower_cira_config_name_idx ON ciraconfigs ((lower(cira_config_name)));
CREATE UNIQUE INDEX lower_profile_name_idx ON profiles ((lower(profile_name)));
CREATE UNIQUE INDEX lower_name_suffix_idx ON domains ((lower(name)), (lower(domain_suffix)));
CREATE UNIQUE INDEX lower_wireless_profile_name_idx ON wirelessconfigs ((lower(wireless_profile_name)));
CREATE UNIQUE INDEX wifi_profile_priority ON profiles_wirelessconfigs((lower(wireless_profile_name)), (lower(profile_name)), priority);
