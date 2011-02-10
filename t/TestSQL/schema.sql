CREATE TABLE `employees` (
`id` int(8) NOT NULL auto_increment,
`f_name` varchar(30) NOT NULL,
`l_name` varchar(30) NOT NULL,
`manager_id` int(8)  NOT NULL,
`desk_id`    int(8)  NOT NULL,
PRIMARY KEY (`id`)   
) TYPE=MyISAM;

CREATE TABLE `employees_responsibilities` (
`id` int(8) NOT NULL auto_increment,
`employee_id` int(8)  NOT NULL,
`responsibilities_id` int(8) NOT NULL,
PRIMARY KEY (`id`)   
) TYPE=MyISAM;

CREATE TABLE `responsibilities` (
`id` int(8) NOT NULL auto_increment,
`name` varchar(30) NOT NULL,
`description` TEXT,
PRIMARY KEY (`id`)     
) TYPE=MyISAM;

CREATE TABLE `desks` (
`id` int(8)  NOT NULL auto_increment,
`location` varchar(30) NOT NULL,
PRIMARY KEY (`id`)    
) TYPE=MyISAM;
