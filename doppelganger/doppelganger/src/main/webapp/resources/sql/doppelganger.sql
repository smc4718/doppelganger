-- 시퀀스
DROP SEQUENCE USER_SEQ;
DROP SEQUENCE FREE_SEQ;
DROP SEQUENCE BLOG_SEQ;
DROP SEQUENCE COMMENT_SEQ;
DROP SEQUENCE UPLOAD_SEQ;
DROP SEQUENCE ATTACH_SEQ;

CREATE SEQUENCE USER_SEQ NOCACHE;
CREATE SEQUENCE FREE_SEQ NOCACHE;
CREATE SEQUENCE BLOG_SEQ NOCACHE;
CREATE SEQUENCE COMMENT_SEQ NOCACHE;
CREATE SEQUENCE UPLOAD_SEQ NOCACHE;
CREATE SEQUENCE ATTACH_SEQ NOCACHE;


-- 테이블
DROP TABLE ATTACH_T;
DROP TABLE UPLOAD_T;
DROP TABLE COMMENT_T;
DROP TABLE BLOG_IMAGE_T;
DROP TABLE BLOG_T;
DROP TABLE FREE_T;
DROP TABLE INACTIVE_USER_T;
DROP TABLE LEAVE_USER_T;
DROP TABLE ACCESS_T;
DROP TABLE USER_T;

-- 가입한 사용자
CREATE TABLE USER_T (
    USER_NO        NUMBER              NOT NULL,        -- PK
    EMAIL          VARCHAR2(100 BYTE)  NOT NULL UNIQUE, -- 이메일을 아이디로 사용
    PW             VARCHAR2(64 BYTE),                   -- SHA-256 암호화 방식 사용
    NAME           VARCHAR2(50 BYTE),                   -- 이름
    GENDER         VARCHAR2(2 BYTE),                    -- M, F, NO
    MOBILE         VARCHAR2(15 BYTE),                   -- 하이픈 제거 후 저장
    POSTCODE       VARCHAR2(5 BYTE),                    -- 우편번호
    ROAD_ADDRESS   VARCHAR2(100 BYTE),                  -- 도로명주소
    JIBUN_ADDRESS  VARCHAR2(100 BYTE),                  -- 지번주소
    DETAIL_ADDRESS VARCHAR2(100 BYTE),                  -- 상세주소
    AGREE          NUMBER              NOT NULL,        -- 서비스 동의 여부(0:필수, 1:이벤트)
    STATE          NUMBER,                              -- 가입형태(0:정상, 1:네이버)
    PW_MODIFIED_AT DATE,                                -- 비밀번호 수정일
    JOINED_AT      DATE,                                -- 가입일
    CONSTRAINT PK_USER PRIMARY KEY(USER_NO)
);

-- 접속 기록
CREATE TABLE ACCESS_T (
    EMAIL    VARCHAR2(100 BYTE) NOT NULL,  -- 접속한 사용자
    LOGIN_AT DATE,                         -- 로그인 일시
    CONSTRAINT FK_USER_ACCESS FOREIGN KEY(EMAIL) REFERENCES USER_T(EMAIL) ON DELETE CASCADE
);

-- 탈퇴한 사용자
CREATE TABLE LEAVE_USER_T (
    EMAIL     VARCHAR2(50 BYTE) NOT NULL UNIQUE,  -- 탈퇴한 사용자 이메일
    JOINED_AT DATE,                               -- 가입일
    LEAVED_AT DATE                                -- 탈퇴일
);

-- 휴면 사용자 (1년 이상 접속 기록이 없으면 휴면 처리)
CREATE TABLE INACTIVE_USER_T (
    USER_NO        NUMBER              NOT NULL,        -- PK
    EMAIL          VARCHAR2(100 BYTE)  NOT NULL UNIQUE, -- 이메일을 아이디로 사용
    PW             VARCHAR2(64 BYTE),                   -- SHA-256 암호화 방식 사용
    NAME           VARCHAR2(50 BYTE),                   -- 이름
    GENDER         VARCHAR2(2 BYTE),                    -- M, F, NO
    MOBILE         VARCHAR2(15 BYTE),                   -- 하이픈 제거 후 저장
    POSTCODE       VARCHAR2(5 BYTE),                    -- 우편번호
    ROAD_ADDRESS   VARCHAR2(100 BYTE),                  -- 도로명주소
    JIBUN_ADDRESS  VARCHAR2(100 BYTE),                  -- 지번주소
    DETAIL_ADDRESS VARCHAR2(100 BYTE),                  -- 상세주소
    AGREE          NUMBER              NOT NULL,        -- 서비스 동의 여부(0:필수, 1:이벤트)
    STATE          NUMBER,                              -- 가입형태(0:정상, 1:네이버)
    PW_MODIFIED_AT DATE,                                -- 비밀번호 수정일
    JOINED_AT      DATE,                                -- 가입일
    INACTIVED_AT   DATE,                                -- 휴면처리일
    CONSTRAINT PK_INACTIVE_USER PRIMARY KEY(USER_NO)
);

-- 자유게시판(계층형-N차, 댓글/대댓글 작성 가능)
CREATE TABLE FREE_T (
    FREE_NO     NUMBER              NOT NULL,
    EMAIL       VARCHAR2(100 BYTE)  NULL,
    CONTENTS    VARCHAR2(4000 BYTE) NOT NULL,
    CREATED_AT  TIMESTAMP           NULL,
    STATUS      NUMBER              NOT NULL,  -- 1:정상, 0:삭제 (실제로 삭제되지 않는 게시판)
    DEPTH       NUMBER              NOT NULL,  -- 0:원글, 1:댓글, 2:대댓글, ...
    GROUP_NO    NUMBER              NOT NULL,  -- 원글과 모든 댓글(댓글, 대댓글)은 동일한 GROUP_NO를 가져야 함
    GROUP_ORDER NUMBER              NOT NULL,  -- 같은 그룹 내 정렬 순서
    CONSTRAINT PK_FREE PRIMARY KEY(FREE_NO),
    CONSTRAINT FK_USER_FREE FOREIGN KEY(EMAIL) REFERENCES USER_T(EMAIL) ON DELETE SET NULL
);

-- 블로그(댓글형)
CREATE TABLE BLOG_T (
    BLOG_NO     NUMBER             NOT NULL,  -- 블로그 번호
    TITLE       VARCHAR2(500 BYTE) NOT NULL,  -- 제목
    CONTENTS    CLOB               NULL,      -- 내용
    USER_NO     NUMBER             NOT NULL,  -- 작성자 번호(NULL인 경우 ON DELETE SET NULL 처리가 가능하고, NOT NULL인 경우 ON DELETE CASCADE 처리가 가능하다.)
    HIT         NUMBER             DEFAULT 0, -- 조회수
    IP          VARCHAR2(30 BYTE)  NULL,      -- IP 주소
    CREATED_AT  VARCHAR2(30 BYTE)  NULL,      -- 작성일 
    MODIFIED_AT VARCHAR2(30 BYTE)  NULL,      -- 수정일
    CONSTRAINT PK_BLOG PRIMARY KEY(BLOG_NO),
    CONSTRAINT FK_USER_BLOG FOREIGN KEY(USER_NO) REFERENCES USER_T(USER_NO) ON DELETE CASCADE  -- 작성자가 삭제되면 블로그도 함께 삭제된다.
);

-- 블로그 이미지 목록
CREATE TABLE BLOG_IMAGE_T (
    BLOG_NO         NUMBER             NOT NULL,
    IMAGE_PATH      VARCHAR2(100 BYTE),
    FILESYSTEM_NAME VARCHAR2(100 BYTE),
    CONSTRAINT FK_BLOG_IMAGE FOREIGN KEY(BLOG_NO) REFERENCES BLOG_T(BLOG_NO) ON DELETE CASCADE
);

-- 블로그 댓글(계층형-1차, 댓글 작성 가능/대댓글 작성 불가능)
CREATE TABLE COMMENT_T (
    COMMENT_NO NUMBER              NOT NULL,
    CONTENTS   VARCHAR2(4000 BYTE) NULL,
    USER_NO    NUMBER              NULL,
    BLOG_NO    NUMBER              NOT NULL,
    CREATED_AT VARCHAR2(30 BYTE)   NULL,
    STATUS     NUMBER              NOT NULL,  -- 1:정상, 0:삭제 (실제로 삭제되지 않는 게시판)
    DEPTH      NUMBER              NOT NULL,  -- 0:원글, 1:댓글, 2:대댓글, ...
    GROUP_NO   NUMBER              NOT NULL,  -- 원글과 모든 댓글(댓글, 대댓글)은 동일한 GROUP_NO를 가져야 함
    CONSTRAINT PK_COMMENT PRIMARY KEY(COMMENT_NO),
    CONSTRAINT FK_USER_COMMENT FOREIGN KEY(USER_NO) REFERENCES USER_T(USER_NO) ON DELETE SET NULL,
    CONSTRAINT FK_BLOG_COMMENT FOREIGN KEY(BLOG_NO) REFERENCES BLOG_T(BLOG_NO) ON DELETE CASCADE
);

-- 업로드 게시판
CREATE TABLE UPLOAD_T (
    UPLOAD_NO    NUMBER             NOT NULL,
    TITLE        VARCHAR2(500 BYTE) NOT NULL,
    CONTENTS     VARCHAR2(4000 BYTE),
    USER_NO      NUMBER             NULL,
    CREATED_AT   VARCHAR2(30 BYTE),
    MODIFIED_AT  VARCHAR2(30 BYTE),
    CONSTRAINT PK_UPLOAD PRIMARY KEY(UPLOAD_NO),
    CONSTRAINT FK_USER_UPLOAD FOREIGN KEY(USER_NO) REFERENCES USER_T(USER_NO) ON DELETE SET NULL
);

-- 첨부 파일 정보
CREATE TABLE ATTACH_T (
    ATTACH_NO         NUMBER             NOT NULL,
    PATH              VARCHAR2(300 BYTE) NOT NULL,
    ORIGINAL_FILENAME VARCHAR2(300 BYTE) NOT NULL,
    FILESYSTEM_NAME   VARCHAR2(300 BYTE) NOT NULL,
    DOWNLOAD_COUNT    NUMBER,
    HAS_THUMBNAIL     NUMBER,                      -- 썸네일이 있으면 1, 없으면 0
    UPLOAD_NO         NUMBER             NOT NULL,
    CONSTRAINT PK_ATTACH PRIMARY KEY(ATTACH_NO),
    CONSTRAINT FK_UPLOAD_ATTACH FOREIGN KEY(UPLOAD_NO) REFERENCES UPLOAD_T(UPLOAD_NO) ON DELETE CASCADE
);


-- 테스트용 INSERT
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'bakery33@naver.com', STANDARD_HASH('1111', 'SHA256'), '사용자1', 'M', '01011111111', '11111', '디지털로', '가산동', '101동 101호', 0, 0, TO_DATE('20231001', 'YYYYMMDD'), TO_DATE('20220101', 'YYYYMMDD'));
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'industry714@google.com', STANDARD_HASH('2222', 'SHA256'), '사용자2', 'F', '01022222222', '22222', '디지털로', '가산동', '101동 101호', 0, 0, TO_DATE('20230801', 'YYYYMMDD'), TO_DATE('20220101', 'YYYYMMDD'));
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'wuruuu99@nate.com', STANDARD_HASH('3333', 'SHA256'), '사용자3', 'NO', '01033333333', '33333', '디지털로', '가산동', '101동 101호', 0, 0, TO_DATE('20230601', 'YYYYMMDD'), TO_DATE('20220101', 'YYYYMMDD'));

INSERT INTO ACCESS_T VALUES('bakery33@naver.com', TO_DATE('20231018', 'YYYYMMDD'));  -- 정상 회원 (user1)
INSERT INTO ACCESS_T VALUES('wuruuu99@nate.com', TO_DATE('20220201', 'YYYYMMDD'));  -- 휴면 회원 (user2)
                                                                                  -- 휴면 회원 (user3)
COMMIT;

-- 원글 입력
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'wuruuu99@nate.com', '내용1', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'bakery33@naver.com', '내용2', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'wuruuu99@nate.com', '내용3', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'industry714@google.com', '내용4', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'industry714@google.com', '내용5', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'industry714@google.com', '내용6', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'industry714@google.com', '내용7', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'bakery33@naver.com', '내용8', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'bakery33@naver.com', '내용9', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'bakery33@naver.com', '내용10', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'wuruuu99@nate.com', '야식으로 치킨들고 도플출석함', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'wuruuu99@nate.com', '헬스 37일차 완료!', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'industry714@google.com', '여행가고 싶다~ 여행지 추천받는다', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'wuruuu99@nate.com', '어제 전여친한테 연락왔는데 읽어? 말어?', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'industry714@google.com', '친구가 내 아이템을 자꾸 따라 사는데?!', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'wuruuu99@nate.com', '먼저 안부연락하고 답장 안하는건 뭘까', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'industry714@google.com', '오랜만에 아빠랑 때밀러 갔는데 엄청나왔어 -_-', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'wuruuu99@nate.com', '혼자 놀기 추천좀', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'bakery33@naver.com', '오늘 점심값 33만원 나왔다 ㄷㄷ', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
INSERT INTO FREE_T VALUES (FREE_SEQ.NEXTVAL, 'bakery33@naver.com', '온라인에서 가짜 삶 사는 사람 보면 어때?', SYSTIMESTAMP, 1, 0, FREE_SEQ.CURRVAL, 0);
COMMIT;