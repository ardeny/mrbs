-- $Id$

ALTER TABLE %DB_TBL_PREFIX%repeat 
ADD COLUMN status    smallint DEFAULT 0 NOT NULL;
