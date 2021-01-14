/*********************************************************************
* Copyright (c) Intel Corporation 2020
* SPDX-License-Identifier: Apache-2.0
**********************************************************************/

CREATE TABLE IF NOT EXISTS ciraconfigs(
      cira_config_name varchar(40),
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
      network_profile_name varchar(40),
      dhcp_enabled BOOLEAN,
      static_ip_shared BOOLEAN,
      ip_sync_enabled BOOLEAN,
      CONSTRAINT networkprofilename UNIQUE(network_profile_name)
    );
CREATE TABLE IF NOT EXISTS profiles(
      profile_name varchar(40),
      activation varchar(20),
      amt_password varchar(40),
      configuration_script text,
      cira_config_name varchar(40) REFERENCES ciraconfigs(cira_config_name),
      generate_random_password BOOLEAN,
      random_password_characters varchar(100),
      random_password_length integer,
      creation_date timestamp,
      created_by varchar(40),
      network_profile_name varchar(40) REFERENCES networkconfigs(network_profile_name),
      mebx_password varchar(40),
      generate_random_mebx_password BOOLEAN,
      random_mebx_password_length integer,
      CONSTRAINT name UNIQUE(profile_name)
    );
CREATE TABLE IF NOT EXISTS domains(
      name varchar(40),
      domain_suffix varchar(40),
      provisioning_cert text,
      provisioning_cert_storage_format varchar(40),
      provisioning_cert_key text,
      creation_date timestamp,
      created_by varchar(40),
      CONSTRAINT domainname UNIQUE(name),
      CONSTRAINT domainsuffix UNIQUE(domain_suffix)
    );

    