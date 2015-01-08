PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
INSERT INTO "schema_migrations" VALUES('20141230011551');
INSERT INTO "schema_migrations" VALUES('20141230011923');
INSERT INTO "schema_migrations" VALUES('20141231151413');
INSERT INTO "schema_migrations" VALUES('20150101223110');
INSERT INTO "schema_migrations" VALUES('20150102144951');
INSERT INTO "schema_migrations" VALUES('20150103193507');
INSERT INTO "schema_migrations" VALUES('20150103193602');
INSERT INTO "schema_migrations" VALUES('20150103193657');
INSERT INTO "schema_migrations" VALUES('20150103200202');
INSERT INTO "schema_migrations" VALUES('20150104142552');
INSERT INTO "schema_migrations" VALUES('20150106135735');
CREATE TABLE "users" ("id" SERIAL PRIMARY KEY NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" timestamp, "remember_created_at" timestamp, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" timestamp, "last_sign_in_at" timestamp, "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "confirmation_token" varchar, "confirmed_at" timestamp, "confirmation_sent_at" timestamp, "unconfirmed_email" varchar, "failed_attempts" integer DEFAULT 0 NOT NULL, "unlock_token" varchar, "locked_at" timestamp, "created_at" timestamp, "updated_at" timestamp, "rcx_skytap_username" varchar, "rcx_skytap_api_token" varchar, "authentication_token" varchar, "clients_update_started_at" timestamp, "clients_update_finished_at" timestamp);
INSERT INTO "users" VALUES(1,'me@mgoldman.com','$2a$10$EMxycvy6qwpRTNHf.a1.5e0VT116jF.fZ9v2cjbVUB0fhfWTtC5DG',NULL,NULL,NULL,5,'2015-01-07 19:42:05.536056','2015-01-07 17:22:23.862484','::1','::1',NULL,'2015-01-07 02:56:20.608464','2015-01-07 02:55:56.566127',NULL,0,NULL,NULL,'2015-01-07 02:55:56.361815','2015-01-07 19:42:05.537744','martin@mgoldman.com','871a468ecd42027a38d9864979e57ffd27c99466',NULL,'2015-01-07 13:54:14.134381','2015-01-07 13:54:17.961769');
CREATE TABLE "rcx_clients" ("id" SERIAL PRIMARY KEY NOT NULL, "user_id" integer, "display_name" varchar, "agent_endpoint_url" varchar, "type" varchar, "skytap_vm_id" integer, "skytap_config_url" varchar, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);
INSERT INTO "rcx_clients" VALUES(7,1,'My Parallels VM','http://10.211.55.3:8789/','HardcodedRcxClient',NULL,NULL,'2015-01-07 13:54:17.929442','2015-01-07 13:54:17.929442');
INSERT INTO "rcx_clients" VALUES(8,1,'Test Config #2\Win7x86 #2','http://services-useast.skytap.com:21881/','RcxSkytap::SkytapRcxClient',4348010,'https://cloud.skytap.com/configurations/3111492','2015-01-07 13:54:17.951697','2015-01-07 13:54:17.951697');
INSERT INTO "rcx_clients" VALUES(9,1,'Test Config\Win7x86','http://services-useast.skytap.com:20343/','RcxSkytap::SkytapRcxClient',4341130,'https://cloud.skytap.com/configurations/3105208','2015-01-07 13:54:17.956518','2015-01-07 13:54:17.956518');
CREATE TABLE "commands" ("id" SERIAL PRIMARY KEY NOT NULL, "name" varchar, "description" text, "path" varchar, "args" varchar, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);
INSERT INTO "commands" VALUES(1,'ping localhost 5 times','','ping.exe','-n 5 127.0.0.1','2015-01-07 03:11:56.726177','2015-01-07 03:11:56.726177');
INSERT INTO "commands" VALUES(2,'say my name','','cmd.exe','/c echo %COMPUTERNAME%','2015-01-07 03:12:09.808917','2015-01-07 03:12:09.808917');
INSERT INTO "commands" VALUES(3,'look in my registry','','reg.exe','query HKLM\Software\Microsoft','2015-01-07 03:12:41.424147','2015-01-07 03:12:41.424147');
CREATE TABLE "batches" ("id" SERIAL PRIMARY KEY NOT NULL, "name" varchar, "user_id" integer, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);
INSERT INTO "batches" VALUES(1,'do some things',1,'2015-01-07 03:14:16.699008','2015-01-07 03:14:16.699008');
CREATE TABLE "batch_commands" ("id" SERIAL PRIMARY KEY NOT NULL, "batch_id" integer, "command_id" integer, "index" integer, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL);
INSERT INTO "batch_commands" VALUES(1,1,1,1,'2015-01-07 03:16:50.142119','2015-01-07 03:16:50.142119');
INSERT INTO "batch_commands" VALUES(2,1,3,2,'2015-01-07 03:17:12.349254','2015-01-07 03:17:12.349254');
INSERT INTO "batch_commands" VALUES(3,1,2,3,'2015-01-07 03:49:50.513004','2015-01-07 03:49:50.513004');
CREATE TABLE "batches_rcx_clients" ("batch_id" integer, "rcx_client_id" integer);
INSERT INTO "batches_rcx_clients" VALUES(1,7);
INSERT INTO "batches_rcx_clients" VALUES(1,8);
INSERT INTO "batches_rcx_clients" VALUES(1,9);
CREATE TABLE "client_batch_commands" ("id" SERIAL PRIMARY KEY NOT NULL, "rcx_client_id" integer, "batch_command_id" integer, "client_guid" varchar, "standard_output" text, "standard_error" text, "has_exited" boolean, "exit_code" integer, "created_at" timestamp NOT NULL, "updated_at" timestamp NOT NULL, "error" varchar);
INSERT INTO "client_batch_commands" VALUES(307,7,1,'c232b5d0-504e-4c0d-bcf1-0e4fa5e1b03b','
Pinging 127.0.0.1 with 32 bytes of data:
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Ping statistics for 127.0.0.1:
    Packets: Sent = 5, Received = 5, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms','','t',0,'2015-01-07 20:26:36.714988','2015-01-07 20:27:16.465777',NULL);
INSERT INTO "client_batch_commands" VALUES(308,8,1,'6098ce49-f211-4072-ab55-b8c5c4fc4c95','
Pinging 127.0.0.1 with 32 bytes of data:
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Ping statistics for 127.0.0.1:
    Packets: Sent = 5, Received = 5, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms','','t',0,'2015-01-07 20:26:36.718494','2015-01-07 20:27:17.161383',NULL);
INSERT INTO "client_batch_commands" VALUES(309,9,1,'40bb4882-4f5e-465b-bfeb-5dee3b6e47a8','
Pinging 127.0.0.1 with 32 bytes of data:
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
Ping statistics for 127.0.0.1:
    Packets: Sent = 5, Received = 5, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms','','t',0,'2015-01-07 20:26:36.721339','2015-01-07 20:27:17.167901',NULL);
INSERT INTO "client_batch_commands" VALUES(310,7,2,'e70b323b-38a5-458b-b8be-8f0838aa3438','
HKEY_LOCAL_MACHINE\Software\Microsoft\.NETFramework
HKEY_LOCAL_MACHINE\Software\Microsoft\Active Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\ADs
HKEY_LOCAL_MACHINE\Software\Microsoft\Advanced INF Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\AppEnv
HKEY_LOCAL_MACHINE\Software\Microsoft\ASP.NET
HKEY_LOCAL_MACHINE\Software\Microsoft\ASP.NET MVC 3
HKEY_LOCAL_MACHINE\Software\Microsoft\ASP.NET MVC 4
HKEY_LOCAL_MACHINE\Software\Microsoft\ASP.NET Web Pages
HKEY_LOCAL_MACHINE\Software\Microsoft\Assistance
HKEY_LOCAL_MACHINE\Software\Microsoft\BidInterface
HKEY_LOCAL_MACHINE\Software\Microsoft\Code Store Database
HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor
HKEY_LOCAL_MACHINE\Software\Microsoft\Communicator
HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography
HKEY_LOCAL_MACHINE\Software\Microsoft\CTF
HKEY_LOCAL_MACHINE\Software\Microsoft\DataAccess
HKEY_LOCAL_MACHINE\Software\Microsoft\DataFactory
HKEY_LOCAL_MACHINE\Software\Microsoft\DbSqlPackageProvider
HKEY_LOCAL_MACHINE\Software\Microsoft\DevDiv
HKEY_LOCAL_MACHINE\Software\Microsoft\Direct3D
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectDraw
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectInput
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectPlay
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectPlay8
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectPlayNATHelp
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectShow
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectX
HKEY_LOCAL_MACHINE\Software\Microsoft\DownloadManager
HKEY_LOCAL_MACHINE\Software\Microsoft\Exchange
HKEY_LOCAL_MACHINE\Software\Microsoft\Expression
HKEY_LOCAL_MACHINE\Software\Microsoft\Feeds
HKEY_LOCAL_MACHINE\Software\Microsoft\FSharp
HKEY_LOCAL_MACHINE\Software\Microsoft\Function Discovery
HKEY_LOCAL_MACHINE\Software\Microsoft\Fusion
HKEY_LOCAL_MACHINE\Software\Microsoft\GenericBootstrapper
HKEY_LOCAL_MACHINE\Software\Microsoft\Help
HKEY_LOCAL_MACHINE\Software\Microsoft\HTMLHelp
HKEY_LOCAL_MACHINE\Software\Microsoft\IdentityCRL
HKEY_LOCAL_MACHINE\Software\Microsoft\IIS Extensions
HKEY_LOCAL_MACHINE\Software\Microsoft\IISExpress
HKEY_LOCAL_MACHINE\Software\Microsoft\IMAPI
HKEY_LOCAL_MACHINE\Software\Microsoft\IMEJP
HKEY_LOCAL_MACHINE\Software\Microsoft\IMEKR
HKEY_LOCAL_MACHINE\Software\Microsoft\IMETC
HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Account Manager
HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Domains
HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer
HKEY_LOCAL_MACHINE\Software\Microsoft\Jet
HKEY_LOCAL_MACHINE\Software\Microsoft\Live Meeting
HKEY_LOCAL_MACHINE\Software\Microsoft\Location
HKEY_LOCAL_MACHINE\Software\Microsoft\Loki
HKEY_LOCAL_MACHINE\Software\Microsoft\Machine Debug Manager
HKEY_LOCAL_MACHINE\Software\Microsoft\MediaPlayer
HKEY_LOCAL_MACHINE\Software\Microsoft\MessengerService
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft Antimalware
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft Data Framework
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft Reference
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SDKs
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server 2008 Redist
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server 2012 Redist
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server Compact Edition
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server Local DB
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server Native Client 11.0
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft Sync Framework
HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft WCF Data Services
HKEY_LOCAL_MACHINE\Software\Microsoft\MMC
HKEY_LOCAL_MACHINE\Software\Microsoft\Mobile
HKEY_LOCAL_MACHINE\Software\Microsoft\MSBuild
HKEY_LOCAL_MACHINE\Software\Microsoft\MSDE
HKEY_LOCAL_MACHINE\Software\Microsoft\MSDN
HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC
HKEY_LOCAL_MACHINE\Software\Microsoft\MSEnvCommunityContent
HKEY_LOCAL_MACHINE\Software\Microsoft\MSF
HKEY_LOCAL_MACHINE\Software\Microsoft\MSLicensing
HKEY_LOCAL_MACHINE\Software\Microsoft\MSN Apps
HKEY_LOCAL_MACHINE\Software\Microsoft\MSOSOAP
HKEY_LOCAL_MACHINE\Software\Microsoft\MSSearch36
HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer
HKEY_LOCAL_MACHINE\Software\Microsoft\NapServer
HKEY_LOCAL_MACHINE\Software\Microsoft\NET Framework Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\NetSh
HKEY_LOCAL_MACHINE\Software\Microsoft\NetworkAccessProtection
HKEY_LOCAL_MACHINE\Software\Microsoft\Notepad
HKEY_LOCAL_MACHINE\Software\Microsoft\ODBC
HKEY_LOCAL_MACHINE\Software\Microsoft\Office
HKEY_LOCAL_MACHINE\Software\Microsoft\OfficeSoftwareProtectionPlatform
HKEY_LOCAL_MACHINE\Software\Microsoft\Outlook Express
HKEY_LOCAL_MACHINE\Software\Microsoft\PCHealth
HKEY_LOCAL_MACHINE\Software\Microsoft\PLA
HKEY_LOCAL_MACHINE\Software\Microsoft\PowerShell
HKEY_LOCAL_MACHINE\Software\Microsoft\Print
HKEY_LOCAL_MACHINE\Software\Microsoft\RADAR
HKEY_LOCAL_MACHINE\Software\Microsoft\Reliability Analysis
HKEY_LOCAL_MACHINE\Software\Microsoft\RFC1156Agent
HKEY_LOCAL_MACHINE\Software\Microsoft\SchedulingAgent
HKEY_LOCAL_MACHINE\Software\Microsoft\Schema Library
HKEY_LOCAL_MACHINE\Software\Microsoft\Shared
HKEY_LOCAL_MACHINE\Software\Microsoft\Shared Tools
HKEY_LOCAL_MACHINE\Software\Microsoft\Shared Tools Location
HKEY_LOCAL_MACHINE\Software\Microsoft\SideShow
HKEY_LOCAL_MACHINE\Software\Microsoft\Silverlight
HKEY_LOCAL_MACHINE\Software\Microsoft\SnippingTool
HKEY_LOCAL_MACHINE\Software\Microsoft\Software
HKEY_LOCAL_MACHINE\Software\Microsoft\Speech
HKEY_LOCAL_MACHINE\Software\Microsoft\SQLNCLI11
HKEY_LOCAL_MACHINE\Software\Microsoft\SQMClient
HKEY_LOCAL_MACHINE\Software\Microsoft\SSDT
HKEY_LOCAL_MACHINE\Software\Microsoft\SSDTBuildUtilities
HKEY_LOCAL_MACHINE\Software\Microsoft\Sync Framework
HKEY_LOCAL_MACHINE\Software\Microsoft\TableTextService
HKEY_LOCAL_MACHINE\Software\Microsoft\Tcpip
HKEY_LOCAL_MACHINE\Software\Microsoft\TeamFoundationServer
HKEY_LOCAL_MACHINE\Software\Microsoft\Terminal Server Client
HKEY_LOCAL_MACHINE\Software\Microsoft\TIP Shared
HKEY_LOCAL_MACHINE\Software\Microsoft\Tpm
HKEY_LOCAL_MACHINE\Software\Microsoft\Tracing
HKEY_LOCAL_MACHINE\Software\Microsoft\Uccplatform
HKEY_LOCAL_MACHINE\Software\Microsoft\uDRM
HKEY_LOCAL_MACHINE\Software\Microsoft\Updates
HKEY_LOCAL_MACHINE\Software\Microsoft\UPnP Device Host
HKEY_LOCAL_MACHINE\Software\Microsoft\VBA
HKEY_LOCAL_MACHINE\Software\Microsoft\Visual JSharp Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\VisualStudio
HKEY_LOCAL_MACHINE\Software\Microsoft\VS 64bit Prerequisite Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\VSCommon
HKEY_LOCAL_MACHINE\Software\Microsoft\VSD3DProviders
HKEY_LOCAL_MACHINE\Software\Microsoft\VSTA
HKEY_LOCAL_MACHINE\Software\Microsoft\VSTA Runtime Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\VSTAHost
HKEY_LOCAL_MACHINE\Software\Microsoft\VSTAHostConfig
HKEY_LOCAL_MACHINE\Software\Microsoft\VSTO Designtime Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\VSTO Runtime Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\VSTO_DT
HKEY_LOCAL_MACHINE\Software\Microsoft\VWDExpress
HKEY_LOCAL_MACHINE\Software\Microsoft\WAB
HKEY_LOCAL_MACHINE\Software\Microsoft\WBEM
HKEY_LOCAL_MACHINE\Software\Microsoft\WCFRIAServices
HKEY_LOCAL_MACHINE\Software\Microsoft\WDExpress
HKEY_LOCAL_MACHINE\Software\Microsoft\Web Tools
HKEY_LOCAL_MACHINE\Software\Microsoft\WebPlatformInstaller
HKEY_LOCAL_MACHINE\Software\Microsoft\WIMMount
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Azure Tools for LightSwitch
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows CE Services
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Desktop Search
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Kits
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Mail
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Messaging Subsystem
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Script Host
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Search
HKEY_LOCAL_MACHINE\Software\Microsoft\WinSimulator
HKEY_LOCAL_MACHINE\Software\Microsoft\Workspaces
HKEY_LOCAL_MACHINE\Software\Microsoft\COM3
HKEY_LOCAL_MACHINE\Software\Microsoft\DFS
HKEY_LOCAL_MACHINE\Software\Microsoft\Driver Signing
HKEY_LOCAL_MACHINE\Software\Microsoft\EnterpriseCertificates
HKEY_LOCAL_MACHINE\Software\Microsoft\EventSystem
HKEY_LOCAL_MACHINE\Software\Microsoft\MSMQ
HKEY_LOCAL_MACHINE\Software\Microsoft\Non-Driver Signing
HKEY_LOCAL_MACHINE\Software\Microsoft\Ole
HKEY_LOCAL_MACHINE\Software\Microsoft\Ras
HKEY_LOCAL_MACHINE\Software\Microsoft\Rpc
HKEY_LOCAL_MACHINE\Software\Microsoft\SystemCertificates
HKEY_LOCAL_MACHINE\Software\Microsoft\TermServLicensing
HKEY_LOCAL_MACHINE\Software\Microsoft\Transaction Server','','t',0,'2015-01-07 20:26:36.727896','2015-01-07 20:27:48.354445',NULL);
INSERT INTO "client_batch_commands" VALUES(311,8,2,'1f470eda-d589-4275-8782-f2a714c48e8e','','','f',0,'2015-01-07 20:26:36.730870','2015-01-07 20:27:18.324224','ActiveRecord::StatementInvalid while performing #<ExecuteJob:0x007fdea9e16128>: SQLite3::BusyException: database is locked: UPDATE "client_batch_commands" SET "client_guid" = ?, "has_exited" = ?, "exit_code" = ?, "standard_error" = ?, "standard_output" = ?, "updated_at" = ? WHERE "client_batch_commands"."id" = ?
["/Users/martin/.rvm/gems/ruby-2.1.5/gems/sqlite3-1.3.10/lib/sqlite3/statement.rb:108:in `step''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sqlite3-1.3.10/lib/sqlite3/statement.rb:108:in `block in each''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sqlite3-1.3.10/lib/sqlite3/statement.rb:107:in `loop''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sqlite3-1.3.10/lib/sqlite3/statement.rb:107:in `each''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/sqlite3_adapter.rb:318:in `to_a''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/sqlite3_adapter.rb:318:in `block in exec_query''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/abstract_adapter.rb:466:in `block in log''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/notifications/instrumenter.rb:20:in `instrument''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/abstract_adapter.rb:460:in `log''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/sqlite3_adapter.rb:297:in `exec_query''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/sqlite3_adapter.rb:323:in `exec_delete''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/abstract/database_statements.rb:114:in `update''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/abstract/query_cache.rb:14:in `update''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/relation.rb:88:in `_update_record''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/persistence.rb:512:in `_update_record''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/locking/optimistic.rb:70:in `_update_record''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/attribute_methods/dirty.rb:123:in `_update_record''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/callbacks.rb:310:in `block in _update_record''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:88:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:88:in `_run_callbacks''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:734:in `_run_update_callbacks''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/callbacks.rb:310:in `_update_record''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/timestamp.rb:70:in `_update_record''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/persistence.rb:501:in `create_or_update''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/callbacks.rb:302:in `block in create_or_update''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:117:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:117:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:169:in `block in halting''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:169:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:169:in `block in halting''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:92:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:92:in `_run_callbacks''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:734:in `_run_save_callbacks''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/callbacks.rb:302:in `create_or_update''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/persistence.rb:142:in `save!''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/validations.rb:43:in `save!''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/attribute_methods/dirty.rb:29:in `save!''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/transactions.rb:291:in `block in save!''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/transactions.rb:347:in `block in with_transaction_returning_status''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/abstract/database_statements.rb:213:in `block in transaction''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/abstract/transaction.rb:188:in `within_new_transaction''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/connection_adapters/abstract/database_statements.rb:213:in `transaction''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/transactions.rb:220:in `transaction''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/transactions.rb:344:in `with_transaction_returning_status''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activerecord-4.2.0/lib/active_record/transactions.rb:291:in `save!''", "/Users/martin/src/bloc/RcxOrchestrator/app/models/client_batch_command.rb:94:in `update_from_client_result''", "/Users/martin/src/bloc/RcxOrchestrator/app/models/client_batch_command.rb:11:in `start!''", "/Users/martin/src/bloc/RcxOrchestrator/app/jobs/execute_job.rb:23:in `start_work''", "/Users/martin/src/bloc/RcxOrchestrator/app/jobs/rcx_command_job.rb:32:in `perform''", "/Users/martin/src/bloc/RcxOrchestrator/app/jobs/execute_job.rb:27:in `perform''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/execution.rb:32:in `block in perform_now''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:117:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:117:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:338:in `block (2 levels) in simple''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/logging.rb:23:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/logging.rb:23:in `block (4 levels) in <module:Logging>''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/notifications.rb:164:in `block in instrument''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/notifications/instrumenter.rb:20:in `instrument''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/notifications.rb:164:in `instrument''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/logging.rb:22:in `block (3 levels) in <module:Logging>''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/logging.rb:43:in `block in tag_logger''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/tagged_logging.rb:68:in `block in tagged''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/tagged_logging.rb:26:in `tagged''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/tagged_logging.rb:68:in `tagged''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/logging.rb:43:in `tag_logger''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/logging.rb:19:in `block (2 levels) in <module:Logging>''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:436:in `instance_exec''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:436:in `block in make_lambda''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:337:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:337:in `block in simple''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:92:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:92:in `_run_callbacks''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:734:in `_run_perform_callbacks''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activesupport-4.2.0/lib/active_support/callbacks.rb:81:in `run_callbacks''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/execution.rb:31:in `perform_now''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/execution.rb:21:in `execute''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/activejob-4.2.0/lib/active_job/queue_adapters/sidekiq_adapter.rb:40:in `perform''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/processor.rb:75:in `execute_job''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/processor.rb:52:in `block (2 levels) in process''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/chain.rb:127:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/chain.rb:127:in `block in invoke''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/server/active_record.rb:6:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/chain.rb:129:in `block in invoke''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/server/retry_jobs.rb:74:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/chain.rb:129:in `block in invoke''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/server/logging.rb:11:in `block in call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/logging.rb:22:in `with_context''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/server/logging.rb:7:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/chain.rb:129:in `block in invoke''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/chain.rb:132:in `call''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/middleware/chain.rb:132:in `invoke''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/processor.rb:51:in `block in process''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/processor.rb:98:in `stats''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/sidekiq-3.3.0/lib/sidekiq/processor.rb:50:in `process''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/celluloid-0.16.0/lib/celluloid/calls.rb:26:in `public_send''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/celluloid-0.16.0/lib/celluloid/calls.rb:26:in `dispatch''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/celluloid-0.16.0/lib/celluloid/calls.rb:122:in `dispatch''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/celluloid-0.16.0/lib/celluloid/cell.rb:60:in `block in invoke''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/celluloid-0.16.0/lib/celluloid/cell.rb:71:in `block in task''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/celluloid-0.16.0/lib/celluloid/actor.rb:357:in `block in task''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/celluloid-0.16.0/lib/celluloid/tasks.rb:57:in `block in initialize''", "/Users/martin/.rvm/gems/ruby-2.1.5/gems/celluloid-0.16.0/lib/celluloid/tasks/task_fiber.rb:15:in `block in create''"]');
INSERT INTO "client_batch_commands" VALUES(312,9,2,'1cd6fdfe-9de2-4b0b-a9b6-5d4c15c1248c','
HKEY_LOCAL_MACHINE\Software\Microsoft\.NETFramework
HKEY_LOCAL_MACHINE\Software\Microsoft\Active Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\ADs
HKEY_LOCAL_MACHINE\Software\Microsoft\Advanced INF Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\ALG
HKEY_LOCAL_MACHINE\Software\Microsoft\ASP.NET
HKEY_LOCAL_MACHINE\Software\Microsoft\Assistance
HKEY_LOCAL_MACHINE\Software\Microsoft\BidInterface
HKEY_LOCAL_MACHINE\Software\Microsoft\COM3
HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor
HKEY_LOCAL_MACHINE\Software\Microsoft\Connect to a Network Projector
HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography
HKEY_LOCAL_MACHINE\Software\Microsoft\CTF
HKEY_LOCAL_MACHINE\Software\Microsoft\DataAccess
HKEY_LOCAL_MACHINE\Software\Microsoft\DataFactory
HKEY_LOCAL_MACHINE\Software\Microsoft\DevDiv
HKEY_LOCAL_MACHINE\Software\Microsoft\Dfrg
HKEY_LOCAL_MACHINE\Software\Microsoft\Direct3D
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectDraw
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectInput
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectMusic
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectPlay
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectPlay8
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectPlayNATHelp
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectShow
HKEY_LOCAL_MACHINE\Software\Microsoft\DirectX
HKEY_LOCAL_MACHINE\Software\Microsoft\DownloadManager
HKEY_LOCAL_MACHINE\Software\Microsoft\Driver Signing
HKEY_LOCAL_MACHINE\Software\Microsoft\DRM
HKEY_LOCAL_MACHINE\Software\Microsoft\DVR
HKEY_LOCAL_MACHINE\Software\Microsoft\DXP
HKEY_LOCAL_MACHINE\Software\Microsoft\EnterpriseCertificates
HKEY_LOCAL_MACHINE\Software\Microsoft\EventSystem
HKEY_LOCAL_MACHINE\Software\Microsoft\Exchange
HKEY_LOCAL_MACHINE\Software\Microsoft\Fax
HKEY_LOCAL_MACHINE\Software\Microsoft\Feeds
HKEY_LOCAL_MACHINE\Software\Microsoft\FlashConfig
HKEY_LOCAL_MACHINE\Software\Microsoft\FTH
HKEY_LOCAL_MACHINE\Software\Microsoft\Function Discovery
HKEY_LOCAL_MACHINE\Software\Microsoft\Fusion
HKEY_LOCAL_MACHINE\Software\Microsoft\GPUPipeline
HKEY_LOCAL_MACHINE\Software\Microsoft\HTMLHelp
HKEY_LOCAL_MACHINE\Software\Microsoft\IdentityCRL
HKEY_LOCAL_MACHINE\Software\Microsoft\IdentityStore
HKEY_LOCAL_MACHINE\Software\Microsoft\IMAPI
HKEY_LOCAL_MACHINE\Software\Microsoft\IMEJP
HKEY_LOCAL_MACHINE\Software\Microsoft\IMEKR
HKEY_LOCAL_MACHINE\Software\Microsoft\IMETC
HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Account Manager
HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Domains
HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer
HKEY_LOCAL_MACHINE\Software\Microsoft\IsoBurn
HKEY_LOCAL_MACHINE\Software\Microsoft\Jet
HKEY_LOCAL_MACHINE\Software\Microsoft\MediaCenterPeripheral
HKEY_LOCAL_MACHINE\Software\Microsoft\MediaPlayer
HKEY_LOCAL_MACHINE\Software\Microsoft\MessengerService
HKEY_LOCAL_MACHINE\Software\Microsoft\MigWiz
HKEY_LOCAL_MACHINE\Software\Microsoft\MMC
HKEY_LOCAL_MACHINE\Software\Microsoft\Mobile
HKEY_LOCAL_MACHINE\Software\Microsoft\MSBuild
HKEY_LOCAL_MACHINE\Software\Microsoft\MSDE
HKEY_LOCAL_MACHINE\Software\Microsoft\MSDTC
HKEY_LOCAL_MACHINE\Software\Microsoft\MSF
HKEY_LOCAL_MACHINE\Software\Microsoft\MSLicensing
HKEY_LOCAL_MACHINE\Software\Microsoft\MSN Apps
HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer
HKEY_LOCAL_MACHINE\Software\Microsoft\Multimedia
HKEY_LOCAL_MACHINE\Software\Microsoft\NapServer
HKEY_LOCAL_MACHINE\Software\Microsoft\NET Framework Setup
HKEY_LOCAL_MACHINE\Software\Microsoft\NetSh
HKEY_LOCAL_MACHINE\Software\Microsoft\Network
HKEY_LOCAL_MACHINE\Software\Microsoft\NetworkAccessProtection
HKEY_LOCAL_MACHINE\Software\Microsoft\Non-Driver Signing
HKEY_LOCAL_MACHINE\Software\Microsoft\Notepad
HKEY_LOCAL_MACHINE\Software\Microsoft\ODBC
HKEY_LOCAL_MACHINE\Software\Microsoft\Office
HKEY_LOCAL_MACHINE\Software\Microsoft\Ole
HKEY_LOCAL_MACHINE\Software\Microsoft\Outlook Express
HKEY_LOCAL_MACHINE\Software\Microsoft\PLA
HKEY_LOCAL_MACHINE\Software\Microsoft\PowerShell
HKEY_LOCAL_MACHINE\Software\Microsoft\Print
HKEY_LOCAL_MACHINE\Software\Microsoft\RADAR
HKEY_LOCAL_MACHINE\Software\Microsoft\Ras
HKEY_LOCAL_MACHINE\Software\Microsoft\RAS AutoDial
HKEY_LOCAL_MACHINE\Software\Microsoft\Reliability Analysis
HKEY_LOCAL_MACHINE\Software\Microsoft\RemovalTools
HKEY_LOCAL_MACHINE\Software\Microsoft\RendezvousApps
HKEY_LOCAL_MACHINE\Software\Microsoft\Router
HKEY_LOCAL_MACHINE\Software\Microsoft\Rpc
HKEY_LOCAL_MACHINE\Software\Microsoft\SchedulingAgent
HKEY_LOCAL_MACHINE\Software\Microsoft\Security Center
HKEY_LOCAL_MACHINE\Software\Microsoft\Sensors
HKEY_LOCAL_MACHINE\Software\Microsoft\Shared Tools
HKEY_LOCAL_MACHINE\Software\Microsoft\Shared Tools Location
HKEY_LOCAL_MACHINE\Software\Microsoft\SideShow
HKEY_LOCAL_MACHINE\Software\Microsoft\Speech
HKEY_LOCAL_MACHINE\Software\Microsoft\SQMClient
HKEY_LOCAL_MACHINE\Software\Microsoft\Sync Framework
HKEY_LOCAL_MACHINE\Software\Microsoft\Sysprep
HKEY_LOCAL_MACHINE\Software\Microsoft\SystemCertificates
HKEY_LOCAL_MACHINE\Software\Microsoft\TableTextService
HKEY_LOCAL_MACHINE\Software\Microsoft\TabletTip
HKEY_LOCAL_MACHINE\Software\Microsoft\Tcpip
HKEY_LOCAL_MACHINE\Software\Microsoft\Terminal Server Client
HKEY_LOCAL_MACHINE\Software\Microsoft\TIP Shared
HKEY_LOCAL_MACHINE\Software\Microsoft\TPG
HKEY_LOCAL_MACHINE\Software\Microsoft\Tpm
HKEY_LOCAL_MACHINE\Software\Microsoft\Tracing
HKEY_LOCAL_MACHINE\Software\Microsoft\Transaction Server
HKEY_LOCAL_MACHINE\Software\Microsoft\TV System Services
HKEY_LOCAL_MACHINE\Software\Microsoft\uDRM
HKEY_LOCAL_MACHINE\Software\Microsoft\Updates
HKEY_LOCAL_MACHINE\Software\Microsoft\UPnP Device Host
HKEY_LOCAL_MACHINE\Software\Microsoft\Virtual Machine
HKEY_LOCAL_MACHINE\Software\Microsoft\VisualStudio
HKEY_LOCAL_MACHINE\Software\Microsoft\WAB
HKEY_LOCAL_MACHINE\Software\Microsoft\WBEM
HKEY_LOCAL_MACHINE\Software\Microsoft\WIMMount
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Defender
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Desktop Search
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Mail
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Media Device Manager
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Media Foundation
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Media Player NSS
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Messaging Subsystem
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Photo Viewer
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Portable Devices
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Script Host
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Search
HKEY_LOCAL_MACHINE\Software\Microsoft\Wisp
HKEY_LOCAL_MACHINE\Software\Microsoft\Workspaces
HKEY_LOCAL_MACHINE\Software\Microsoft\WwanSvc','','t',0,'2015-01-07 20:26:36.734551','2015-01-07 20:27:48.501907',NULL);
INSERT INTO "client_batch_commands" VALUES(313,7,3,'f2455185-21ee-42b6-9024-cab6ac312089','
WIN7VM','','t',0,'2015-01-07 20:26:36.740599','2015-01-07 20:27:49.388158',NULL);
INSERT INTO "client_batch_commands" VALUES(314,8,3,NULL,NULL,NULL,NULL,NULL,'2015-01-07 20:26:36.743948','2015-01-07 20:26:36.743948',NULL);
INSERT INTO "client_batch_commands" VALUES(315,9,3,'a1ff66bd-b661-4daa-a87d-6dca7708b8ee','
WIN7PRO32','','t',0,'2015-01-07 20:26:36.747078','2015-01-07 20:27:49.516162',NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "index_users_on_confirmation_token" ON "users" ("confirmation_token");
CREATE UNIQUE INDEX "index_users_on_unlock_token" ON "users" ("unlock_token");
CREATE INDEX "index_batches_rcx_clients_on_batch_id" ON "batches_rcx_clients" ("batch_id");
CREATE INDEX "index_batches_rcx_clients_on_rcx_client_id" ON "batches_rcx_clients" ("rcx_client_id");
COMMIT;
