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
CREATE TABLE IF NOT EXISTS networkconfigs(
      network_profile_name citext NOT NULL,
      dhcp_enabled BOOLEAN NOT NULL,
      static_ip_shared BOOLEAN NOT NULL,
      ip_sync_enabled BOOLEAN NOT NULL,
      CONSTRAINT networkprofilename UNIQUE(network_profile_name)
    );
CREATE TABLE IF NOT EXISTS profiles(
      profile_name citext NOT NULL,
      activation varchar(20) NOT NULL,
      amt_password varchar(40),
      configuration_script text,
      cira_config_name citext REFERENCES ciraconfigs(cira_config_name),
      generate_random_password BOOLEAN NOT NULL,
      random_password_characters varchar(100),
      random_password_length integer,
      creation_date timestamp,
      created_by varchar(40),
      network_profile_name citext REFERENCES networkconfigs(network_profile_name),
      mebx_password varchar(40),
      generate_random_mebx_password BOOLEAN NOT NULL,
      random_mebx_password_length integer,
      tags text[],
      CONSTRAINT name UNIQUE(profile_name)
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
CREATE UNIQUE INDEX lower_network_profile_name_idx ON networkconfigs ((lower(network_profile_name)));
CREATE UNIQUE INDEX lower_profile_name_idx ON profiles ((lower(profile_name)));
CREATE UNIQUE INDEX lower_name_suffix_idx ON domains ((lower(name)), (lower(domain_suffix)));

INSERT INTO public.networkconfigs(
  network_profile_name, dhcp_enabled, static_ip_shared, ip_sync_enabled) 
  values('dhcp_disabled', false, true, true);
INSERT INTO public.networkconfigs(
  network_profile_name, dhcp_enabled, static_ip_shared, ip_sync_enabled)  
  values('dhcp_enabled', true, false, true);

