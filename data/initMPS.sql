/*********************************************************************
* Copyright (c) Intel Corporation 2021
* SPDX-License-Identifier: Apache-2.0
**********************************************************************/
SELECT 'CREATE DATABASE mpsdb' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'mpsdb')\gexec

\connect mpsdb

CREATE TABLE IF NOT EXISTS devices(
      guid uuid NOT NULL,
      tags text[],
      hostname varchar(256),
      mpsinstance text, 
      connectionstatus boolean,
      mpsusername text,
      tenantid varchar(36) NOT NULL,
      friendlyname varchar(256),
      dnssuffix varchar(256),
      lastconnected timestamp with time zone,
      lastseen timestamp with time zone,
      lastdisconnected timestamp with time zone,
      deviceinfo JSON,
      CONSTRAINT device_guid UNIQUE(guid),
      PRIMARY KEY (guid, tenantid)
    ); 
