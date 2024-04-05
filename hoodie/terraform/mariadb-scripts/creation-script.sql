create database hoodiedb;

-- creating user
CREATE USER 'catalogue_user'@'%' IDENTIFIED BY 'catalogue_pass';
CREATE USER 'catalogue_user'@'localhost' IDENTIFIED BY 'catalogue_pass';

grant all privileges on *.* to 'catalogue_user'@'localhost';
grant all privileges on *.* to 'catalogue_user'@'%';

delete from mysql.user where User='';
flush privileges;

-- and now the table and data for hoodiedb
use hoodiedb;
CREATE TABLE IF NOT EXISTS hoodie (
                                      hoodie_id varchar(40) NOT NULL,
                                      name varchar(20),
                                      description varchar(200),
                                      price float,
                                      count int,
                                      image_url_1 varchar(40),
                                      image_url_2 varchar(40),
                                      PRIMARY KEY(hoodie_id)
);

CREATE TABLE IF NOT EXISTS tag (
                                   tag_id MEDIUMINT NOT NULL AUTO_INCREMENT,
                                   name varchar(20),
                                   PRIMARY KEY(tag_id)
);

CREATE TABLE IF NOT EXISTS dimension (
                                         size_id MEDIUMINT NOT NULL AUTO_INCREMENT,
                                         name varchar(20),
                                         label varchar(20),
                                         PRIMARY KEY(size_id)
);

CREATE TABLE IF NOT EXISTS hoodie_tag (
                                          hoodie_id varchar(40),
                                          tag_id MEDIUMINT NOT NULL,
                                          FOREIGN KEY (hoodie_id)
                                              REFERENCES hoodie(hoodie_id),
                                          FOREIGN KEY(tag_id)
                                              REFERENCES tag(tag_id)
);

CREATE TABLE IF NOT EXISTS hoodie_size (
                                           hoodie_id varchar(40),
                                           size_id MEDIUMINT NOT NULL,
                                           FOREIGN KEY (hoodie_id)
                                               REFERENCES hoodie(hoodie_id),
                                           FOREIGN KEY(size_id)
                                               REFERENCES dimension(size_id)
);

CREATE TABLE IF NOT EXISTS cart_item (
                                         cart_id MEDIUMINT NOT NULL AUTO_INCREMENT,
                                         order_id varchar(40) NOT NULL,
                                         hoodie_id varchar(40),
                                         dimension varchar(20),
                                         quantity int,
                                         price float,
                                         status varchar(40) NOT NULL,
                                         created_at timestamp DEFAULT CURRENT_TIMESTAMP,
                                         completed_at timestamp DEFAULT CURRENT_TIMESTAMP,
                                         expires_at timestamp DEFAULT CURRENT_TIMESTAMP,
                                         PRIMARY KEY(cart_id),
                                         FOREIGN KEY (hoodie_id)
                                             REFERENCES hoodie(hoodie_id)
);

INSERT INTO hoodie VALUES ("6d62d909-f957-430e-8689-b5129c0bb75e", "Cloudsoft special", "Limited issue Cloudsoft hoodies.", 17.15, 33, "/images/green_and_blue.png", "/images/navy_blue.png");
INSERT INTO hoodie VALUES ("a0a4f044-b040-410d-8ead-4de0446aec7e", "Green hoodie", "A mature hoodie, reminding you of healthy green grass of the Highlands", 7.99, 115, "/images/green_front.png", "/images/green_back.png");
INSERT INTO hoodie VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", "Navy hoodie", "Go dark, go mysterious. You know you want to",  17.32, 738, "/images/navy_front.png", "/images/navy_back.png");
INSERT INTO hoodie VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc34d", "Red hoodie", "Red is not our colour, but it might be yours. We thought of that.",  15.00, 820, "/images/red_front.png", "/images/red_back.png");
INSERT INTO hoodie VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6e0b", "Blue hoodie", "If you like blue clear skies as we rarely see here in Scotland, you will love this hoodie.",  99.99, 1, "/images/blue_front.png", "/images/blue_back.png");
INSERT INTO hoodie VALUES ("01234567-8901-2345-6789-012345678901", "Glitchy Hoodie", "Will you dare to try the glitch?",  99999.99, 9999, "/images/glitch_front.png", "/images/glitch_back.png");

INSERT INTO hoodie VALUES ("a0a4f044-b040-410d-8ead-4de0446aecaa", "Black hat", "A very cool hat, for the times the sunshine heats your hair.", 7.99, 115, "/images/cap_black_main.png", "/images/cap_black_front.png");
INSERT INTO hoodie VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29abb", "Navy hat", "A very cool navy hat. Makes you look good on a boat and in the city too.",  17.32, 738, "/images/cap_navy_main.png", "/images/cap_navy_front.png");
INSERT INTO hoodie VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc3cc", "Red hat", "Red is not our colour, but it might be yours. A perfect hat for all the times when you want to be noticed.",  15.00, 820, "/images/cap_red_main.png", "/images/cap_red_front.png");
INSERT INTO hoodie VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6edd", "Navy hat(v2)", "When you want a hat that makes a statement.",  99.99, 1, "/images/hat_navy_main.png", "/images/hat_navy_front.png");

INSERT INTO tag (tag_id, name) VALUES (1,"geek");
INSERT INTO tag (tag_id, name) VALUES (2,"formal");
INSERT INTO tag (tag_id, name) VALUES (3, "blue");
INSERT INTO tag (tag_id, name) VALUES (4, "skin");
INSERT INTO tag (tag_id, name) VALUES (5, "red");
INSERT INTO tag (tag_id, name) VALUES (6, "action");
INSERT INTO tag (tag_id, name) VALUES (7, "red");
INSERT INTO tag (tag_id, name) VALUES (8, "black");
INSERT INTO tag (tag_id, name) VALUES (9, "magic");
INSERT INTO tag (tag_id, name) VALUES (10,"green");
INSERT INTO tag (tag_id, name) VALUES (11,"hat");

INSERT INTO dimension (size_id, name, label) VALUES (1,"XS", "Extra Small");
INSERT INTO dimension (size_id, name, label) VALUES (2,"S", "Small");
INSERT INTO dimension (size_id, name, label) VALUES (3, "M", "Medium");
INSERT INTO dimension (size_id, name, label) VALUES (4, "L", "Large");
INSERT INTO dimension (size_id, name, label) VALUES (5, "XL", "Extra Large");
INSERT INTO dimension (size_id, name, label) VALUES (6, "XXL", "Extra-extra Large");
INSERT INTO dimension (size_id, name, label) VALUES (7, "XXXL","Extremely Large");
INSERT INTO dimension (size_id, name, label) VALUES (8, "H", "Humongous");

INSERT INTO hoodie_tag VALUES ("6d62d909-f957-430e-8689-b5129c0bb75e", 1);
INSERT INTO hoodie_tag VALUES ("6d62d909-f957-430e-8689-b5129c0bb75e", 2);
INSERT INTO hoodie_tag VALUES ("a0a4f044-b040-410d-8ead-4de0446aec7e", 10);
INSERT INTO hoodie_tag VALUES ("a0a4f044-b040-410d-8ead-4de0446aec7e", 8);
INSERT INTO hoodie_tag VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", 4);
INSERT INTO hoodie_tag VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", 6);
INSERT INTO hoodie_tag VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", 8);
INSERT INTO hoodie_tag VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", 3);
INSERT INTO hoodie_tag VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc34d", 5);
INSERT INTO hoodie_tag VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc34d", 9);
INSERT INTO hoodie_tag VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc34d", 2);
INSERT INTO hoodie_tag VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6e0b", 3);
INSERT INTO hoodie_tag VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6e0b", 8);
INSERT INTO hoodie_tag VALUES ("a0a4f044-b040-410d-8ead-4de0446aecaa", 11);
INSERT INTO hoodie_tag VALUES ("a0a4f044-b040-410d-8ead-4de0446aecaa", 8);
INSERT INTO hoodie_tag VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29abb", 3);
INSERT INTO hoodie_tag VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29abb", 11);
INSERT INTO hoodie_tag VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc3cc", 1);
INSERT INTO hoodie_tag VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc3cc", 11);
INSERT INTO hoodie_tag VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6edd", 3);
INSERT INTO hoodie_tag VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6edd", 11);


INSERT INTO hoodie_size VALUES ("6d62d909-f957-430e-8689-b5129c0bb75e", 1);
INSERT INTO hoodie_size VALUES ("6d62d909-f957-430e-8689-b5129c0bb75e", 2);
INSERT INTO hoodie_size VALUES ("6d62d909-f957-430e-8689-b5129c0bb75e", 3);
INSERT INTO hoodie_size VALUES ("6d62d909-f957-430e-8689-b5129c0bb75e", 4);
INSERT INTO hoodie_size VALUES ("a0a4f044-b040-410d-8ead-4de0446aec7e", 3);
INSERT INTO hoodie_size VALUES ("a0a4f044-b040-410d-8ead-4de0446aec7e", 4);
INSERT INTO hoodie_size VALUES ("a0a4f044-b040-410d-8ead-4de0446aec7e", 5);
INSERT INTO hoodie_size VALUES ("a0a4f044-b040-410d-8ead-4de0446aec7e", 6);
INSERT INTO hoodie_size VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", 3);
INSERT INTO hoodie_size VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", 4);
INSERT INTO hoodie_size VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", 8);
INSERT INTO hoodie_size VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29a38", 7);
INSERT INTO hoodie_size VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc34d", 5);
INSERT INTO hoodie_size VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc34d", 8);
INSERT INTO hoodie_size VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc34d", 2);
INSERT INTO hoodie_size VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6e0b", 3);
INSERT INTO hoodie_size VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6e0b", 8);
INSERT INTO hoodie_size VALUES ("a0a4f044-b040-410d-8ead-4de0446aecaa", 2);
INSERT INTO hoodie_size VALUES ("a0a4f044-b040-410d-8ead-4de0446aecaa", 8);
INSERT INTO hoodie_size VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29abb", 1);
INSERT INTO hoodie_size VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29abb", 3);
INSERT INTO hoodie_size VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29abb", 3);
INSERT INTO hoodie_size VALUES ("808a2de1-1aaa-4c25-a9b9-6612e8f29abb", 4);
INSERT INTO hoodie_size VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc3cc", 2);
INSERT INTO hoodie_size VALUES ("510a0d7e-8e83-4193-b483-e27e09ddc3cc", 4);
INSERT INTO hoodie_size VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6edd", 7);
INSERT INTO hoodie_size VALUES ("03fef6ac-1896-4ce8-bd69-b798f85c6edd", 6);
INSERT INTO hoodie_size VALUES ("01234567-8901-2345-6789-012345678901", 1);
INSERT INTO hoodie_size VALUES ("01234567-8901-2345-6789-012345678901", 7);