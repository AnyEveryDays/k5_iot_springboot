DROP DATABASE IF EXISTS `mini-project-task-manager`;
CREATE DATABASE `mini-project-task-manager`;

use `mini-project-task-manager`;

DROP TABLE IF EXISTS `users`; 
CREATE TABLE IF NOT EXISTS `users` (
    id			BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username 	VARCHAR(50) NOT NULL,
    password 	VARCHAR(255) NOT NULL,
    nickname 	VARCHAR(50) NOT NULL,
    email 		VARCHAR(255) NOT NULL,
    gender 		VARCHAR(10),
    created_at 	DATETIME(6) NOT NULL,
    updated_at 	DATETIME(6) NOT NULL,

    CONSTRAINT `uk_username` UNIQUE (username),
    CONSTRAINT `uk_users_email` UNIQUE (email),
    CONSTRAINT `uk_users_nickname` UNIQUE (nickname),
    CONSTRAINT `chk_users_gender` CHECK(gender IN ('MALE', 'FEMALE'))

    ) ENGINE=InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '사용자';

DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE IF NOT EXISTS `user_roles` (
    id			BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id 	BIGINT NOT NULL,
    role	 	VARCHAR(30) NOT NULL,

    CONSTRAINT `fk_user_roles_user_id`
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT `uk_user_roles` UNIQUE (user_id, role),
    CONSTRAINT `chk_user_roles_role` CHECK (role IN ('USER', 'AUTHOR','OWNER','ADMIN'))

    ) ENGINE=InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '사용자 권한';

DROP TABLE IF EXISTS `projects`;
CREATE TABLE IF NOT EXISTS `projects`(
    id 				BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_title	VARCHAR(200) NOT NULL,
    project_content	VARCHAR(255),
    user_id 		BIGINT NOT NULL,
    created_at		DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at		TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT `fk_project_user` FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE

    ) ENGINE=InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '프로젝트';

DROP TABLE IF EXISTS `tasks`;
CREATE TABLE IF NOT EXISTS `tasks`(
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    author_id	BIGINT NOT NULL,
    project_id  BIGINT NOT NULL,
    title       VARCHAR(200) NOT NULL,
    content		LONGTEXT NOT NULL,
    author		VARCHAR(100) NOT NULL,
    status      VARCHAR(50) NOT NULL DEFAULT 'TODO',
    priority    VARCHAR(50) NOT NULL DEFAULT 'MEDIUM',
    due_date    DATE NOT NULL,
    created_at  DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at  TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT `chk_task_status` CHECK(status IN('TODO','IN_PROGRESS','DONE')),
    CONSTRAINT `chk_task_priority` CHECK(priority IN('LOW','MEDIUM','HIGH')),
    CONSTRAINT `fk_task_project` FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT `fk_task_user` FOREIGN KEY (author_id) REFERENCES users(id),

    INDEX idx_task_project_status (project_id, status),
    INDEX idx_task_author_due (author_id, due_date)

    ) ENGINE=InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '할일';

DROP TABLE IF EXISTS `tags`;
CREATE TABLE IF NOT EXISTS `tags`(
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    tag_name    VARCHAR(100) NOT NULL,
    CONSTRAINT `uq_tag_name` UNIQUE (tag_name)

    ) ENGINE=InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '태그';

DROP TABLE IF EXISTS `task_tags`;
CREATE TABLE IF NOT EXISTS `task_tags` (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    task_id     BIGINT NOT NULL,
    tag_id      BIGINT NOT NULL,
    CONSTRAINT `fk_tasks_id` FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    CONSTRAINT `fk_tags_id` FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE

    )	ENGINE=InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT ='태스크_태그';

DROP TABLE IF EXISTS `comments`;
CREATE TABLE IF NOT EXISTS `comments` (
    id 			BIGINT PRIMARY KEY AUTO_INCREMENT,
    task_id		BIGINT NOT NULL,
    author_id 	BIGINT NOT NULL,
    content		TEXT NOT NULL,
    create_at 	DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT `fk_comment_task` FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    CONSTRAINT `fk_comment_author` FOREIGN KEY (author_id) REFERENCES users(id)

    ) ENGINE=InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '댓글';

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
    id 			BIGINT PRIMARY KEY AUTO_INCREMENT,
    project_id 	BIGINT NOT NULL,
    author_id 	BIGINT NOT NULL,
    title		VARCHAR(300) NOT NULL,
    content 	TEXT NOT NULL,
    created_at 	DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT `fk_noti_project` FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT `fk_noti_author` FOREIGN KEY (author_id) REFERENCES users(id)

    ) ENGINE=InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '공지';

USE `mini-project-task-manager`;