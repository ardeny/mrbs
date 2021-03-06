How to setup an MRBS instance
==========================================================
git clone from git repo
make appropriate changes to web/config.inc.php
*** DO NOT commit local config changes
create mysql database/user
create database tables: mysql -p -u username database < tables.my.sql

How to update
==============
git stash
git pull origin master
git stash pop

Integrating changes from upstream (ie: from sourceforge svn trunk)
====================================================================
* Add the following to .git/config (only need to do this the first time)
[svn-remote "svn"]
	url = svn://svn.code.sf.net/p/mrbs/code/mrbs/trunk
	fetch = :refs/remotes/svn/git-svn
* Then create a branch tracking upstream (only need to do this the first time)
git svn fetch
git checkout -b svntrunk refs/remotes/svn/git-svn
* Then, everytime we need to incorporate upstream changes
git checkout svntrunk
git svn rebase
git checkout master
git merge svntrunk


COPY EXISTING BOOKINGS FROM OLD MRBS pre-1.4.10 NEW MRBS
==========================================================

* Find out the area id and name you want to copy from the old postgresql db eg: Frost is 3
* insert the area id, name into the mrbs_area table, the area name is not important

INSERT INTO mrbs_area(id, area_name) VALUES (3, 'Group Study Rooms');

* Extract rooms for the area into csv file
copy (select id,area_id,room_name,capacity from mrbs_room where area_id=3) to '/tmp/frost_mrbs_room.csv' delimiter ',';

* Extract Data from mrbs_entry for specific rooms into csv file

copy (select id,start_time,end_time,entry_type,repeat_id,room_id,create_by,name,type,description from mrbs_entry where room_id in(2,9)) to '/tmp/frost_mrbs_entry.csv' delimiter ',';

* Load Extracted CSV file into new mysql database. 
$mysql -p -uroot databasename

LOAD DATA INFILE '/tmp/frost_mrbs_room.csv' INTO TABLE mrbs_room FIELDS TERMINATED BY ',' (id,area_id,room_name,capacity);

LOAD DATA INFILE '/tmp/frost_mrbs_entry.csv' INTO TABLE mrbs_entry FIELDS TERMINATED BY ',' (id,start_time,end_time,entry_type,repeat_id,room_id,create_by,name,type,description);


