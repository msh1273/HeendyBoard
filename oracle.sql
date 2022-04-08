-- 게시글 테이블 생성
create table t_board(
no NUMBER primary KEY,
title VARCHAR2(100) not null,
name VARCHAR2(20) not null,
content CLOB not null,
regdate VARCHAR(20) default TO_CHAR(sysdate, 'YYYY/MM/DD HH24:MM:SS'),
readcount number default 0,
password varchar2(128) not null,
board_name varchar2(20) not null
);

-- 시퀀스 생성
CREATE SEQUENCE t_board_no_seq
	START WITH 0
	INCREMENT BY 1;
	
-- 외래키 주입
ALTER TABLE t_board add constraint FK_BOARD_NAME foreign key(board_name) references t_type_board;

-- 데이터 삽입 샘플
INSERT INTO t_board(title, name, password, content, board_name)
		VALUES('하이00', '아작스', 1234, '아작스란', '일반게시판');
        
INSERT INTO t_type_board(board_name) values('일반게시판'); 

-- 게시판 종류 테이블
create table t_type_board(
board_name varchar2(20) primary KEY,
regdate VARCHAR(20) default TO_CHAR(sysdate, 'YYYY/MM/DD HH24:MM:SS')
);

-- 첨부파일 테이블 
create table t_attach(
uuid varchar2(100) not null,
uploadPath varchar2(200) not null,
fileName varchar2(100) not null,
filetype char(1) default 'I',
no number
);
alter table t_attach add constraint pk_attach primary key (uuid);

alter table t_attach add constraint fk_board_attach foreign key(no) references t_board(no);
