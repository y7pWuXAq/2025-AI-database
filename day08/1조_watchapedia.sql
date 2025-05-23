Create Table Member(
    mem_id varchar2(60) Primary key,
    mem_pass varchar2(15) Not Null,
    mem_join date Not Null,
    mem_name varchar2(20) Not Null,
    mem_nick varchar2(20),
    mem_introduction varchar2(100));
    
Create Table Movie(
    movie_id varchar2(10) Primary Key,
    movie_title varchar2(100) Not Null,
    movie_direc varchar2(60) Not Null,
    movie_time varchar2(20) Not Null,
    movie_rating varchar2(20) Not Null,
    movie_genre varchar2(100) Not Null,
    movie_country varchar2(20) Not Null,
    movie_year number(4) Not Null,
    movie_orgname varchar2(100),
    movie_audience varchar2(20),
    movie_netflix number(1) Not Null,
    movie_watcha number(1) Not Null,
    movie_disney number(1) Not Null,
    movie_tving number(1) Not Null,
    movie_wavve number(1) Not Null,
    movie_couplay number(1) Not Null
    );
    
Create Table Series(
    series_id varchar2(10) Primary Key,
    series_title varchar2(100) Not Null,
    series_direc varchar2(60) Not Null,
    series_episode varchar2(20) Not Null,
    series_rating varchar2(20) Not Null,
    series_genre varchar2(100) Not Null,
    series_country varchar2(20) Not Null,
    series_year number(4) Not Null,
    series_broadcast varchar2(20) Not Null,
    series_orgname varchar2(100),
    series_netflix number(1) Not Null,
    series_watcha number(1) Not Null,
    series_disney number(1) Not Null,
    series_tving number(1) Not Null,
    series_wavve number(1) Not Null,
    series_couplay number(1) Not Null
    );

Create Table Book(
    book_id varchar2(10) Primary Key,
    book_title varchar2(50) Not Null,
    book_author varchar2(30) Not Null,
    book_genre varchar2(20) Not Null,
    book_page varchar2(10) Not Null,
    book_rank varchar2(40),
    book_img varchar2(40) Not Null,
    book_detail clob,
    book_author_img varchar2(40),
    book_index clob,
    book_publisher_introduction clob,
    book_aladin number(1) Not Null,
    book_yes24 number(1) Not Null,
    book_kyobo number(1) Not Null
    );
    
Create Table Webtoon(
    webtoon_id varchar2(10) Primary Key,
    webtoon_title varchar2(100) Not Null,
    webtoon_writer varchar2(20) Not Null,
    webtoon_painter varchar2(20) Not Null,
    webtoon_orgwriter varchar2(20),
    webtoon_dramatize varchar2(20),
    webtoon_serial varchar2(20) Not Null,
    webtoon_start date Not Null,
    webtoon_end date,
    webtoon_orgtitle varchar2(100),
    webtoon_genre varchar2(100) Not Null,
    webtoon_introduce clob,
    webtoon_kakao number(1) Not Null,
    webtoon_kakaopage number(1) Not Null,
    webtoon_naver number(1) Not Null,
    webtoon_bomtoon number(1) Not Null,
    webtoon_ridi number(1) Not Null,
    webtoon_watcha number(1) Not Null
);

Create Table Evaluation(
    eval_memid varchar2(60) Not Null,
    eval_contentsid varchar2(10) Not Null,
    eval_title varchar2(100) Not Null,
    eval_date date Not Null,
    eval_score varchar2(10) Not Null,
    eval_comment clob,
    CONSTRAINT Eval_PK Primary key (eval_memid, eval_contentsid),
    CONSTRAINT Eval_FK Foreign key (eval_memid) References Member(mem_id),
    CONSTRAINT Eval_FK2 Foreign Key (eval_contentsid) References Book(book_id),
    CONSTRAINT Eval_FK3 Foreign Key (eval_contentsid) References Movie(movie_id),
    CONSTRAINT Eval_FK4 Foreign Key (eval_contentsid) References Webtoon(webtoon_id),
    CONSTRAINT Eval_FK5 Foreign Key (eval_contentsid) References Series(series_id)
);

