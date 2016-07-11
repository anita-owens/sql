Tables in Dognition Database

%sql SHOW tables
#Tables_in_dognitiondb
complete_tests
dogs
exam_answers
reviews
site_activities
users

%sql SHOW columns FROM dogs
Field	Type	Null	Key	Default	Extra
gender	varchar(255)	YES		None	
birthday	varchar(255)	YES		None	
breed	varchar(255)	YES		None	
weight	int(11)	YES		None	
dog_fixed	tinyint(1)	YES		None	
dna_tested	tinyint(1)	YES		None	
created_at	datetime	NO		None	
updated_at	datetime	NO		None	
dimension	varchar(255)	YES		None	
exclude	tinyint(1)	YES		None	
breed_type	varchar(255)	YES		None	
breed_group	varchar(255)	YES		None	
dog_guid	varchar(60)	YES	MUL	None	
user_guid	varchar(60)	YES	MUL	None	
total_tests_completed	varchar(255)	YES		None	
mean_iti_days	varchar(255)	YES		None	
mean_iti_minutes	varchar(255)	YES		None	
median_iti_days	varchar(255)	YES		None	
median_iti_minutes	varchar(255)	YES		None	
time_diff_between_first_and_last_game_days	varchar(255)	YES		None	
time_diff_between_first_and_last_game_minutes	varchar(255)	YES		None


%sql SHOW columns FROM complete_tests
Field	Type	Null	Key	Default	Extra
created_at	datetime	NO		None	
updated_at	datetime	NO		None	
user_guid	varchar(60)	YES	MUL	None	
dog_guid	varchar(60)	YES	MUL	None	
test_name	varchar(60)	YES		None	
subcategory_name	varchar(60)	YES		None


%sql SHOW columns FROM exam_answers
Field	Type	Null	Key	Default	Extra
script_detail_id	int(11)	YES		None	
subcategory_name	varchar(255)	YES		None	
test_name	varchar(255)	YES		None	
step_type	varchar(255)	YES		None	
start_time	datetime	YES		None	
end_time	datetime	YES		None	
loop_number	int(11)	YES		None	
dog_guid	varchar(60)	YES		None	