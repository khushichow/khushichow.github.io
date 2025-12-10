CREATE TABLE Locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(100),
    location VARCHAR(50)
);


CREATE TABLE Resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    resource_title VARCHAR(100),
    location_id INT,
    description VARCHAR(250),
    intended_clients VARCHAR(250),
    phone VARCHAR(50),
    email VARCHAR(50),
    service_type VARCHAR(50),
    treatment_type VARCHAR(250),
    link VARCHAR(250),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

INSERT INTO Locations 
(company_name, location) 
VALUES ('CAMH', '1051 Queen Street West');
INSERT INTO Locations 
(company_name, location) 
VALUES ('CAMH', '1025 Queen Street West');
INSERT INTO Locations 
(company_name, location) 
VALUES ('CAMH', '60 White Squirrel Way');
INSERT INTO Locations 
(company_name, location) 
VALUES ('CAMH', '80 Workman Way');
INSERT INTO Locations
(company_name, location)
VALUES ('CAMH', '250 College Street')

INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Emergency Department', 1, 'CAMHs Psychiatric Emergency Department provides 24 hours/7 days per week emergency services for adults with mental health and substance issues.', 
'Adults age 16+.', '416 535-8501 ext. 33296', 'N/A', 'Emergency', 'Inpatient experience at CAMH.', 'https://www.camh.ca/en/your-care/programs-and-services/emergency-department');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('RISE', 1, 'This Toronto District School Board (TDSB) academic day school program offers clients under 21 the opportunity to earn high school credits.', 
'Clients aged 14-21 with mental health challenges who are under the care of a psychiatrist.', '416 535-8501 ext. 37702', 'N/A', 
'Youth', 'Program runs 4.5 days a week from September to June in order to complete 3 credits a semester.', 'https://www.camh.ca/en/your-care/programs-and-services/tdsb-academic-day-school-program');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Nicotine Dependence Clinic', 2, 'The Nicotine Dependence Clinic offers several specialized outpatient treatments for anyone who wants to quit or reduce their tobacco use.', 
'Anyone who wants to quit or reduce their tobacco use.', '416 535-8501 ext. 77400', 'N/A', 'Addiction', 'N/A', 'https://www.camh.ca/en/your-care/programs-and-services/nicotine-dependence-clinic');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Therapeutic Brain Intervention Service', 2, 'The Temerty Centre for Therapeutic Brain Intervention offers consultation on clients with refractory and difficult-to-treat psychiatric disorders.',
'Clients with refractory and difficult-to-treat psychiatric disorders.', '416-535-8501 ext. 32130', 'N/A', 'Mental Health', 'Transcranial Direct Current Stimulation (tDCS) involves the delivery of a low intensity electric field to the brain through a small, portable battery-operated device.', 'https://www.camh.ca/en/your-care/programs-and-services/therapeutic-brain-intervention-service');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Aboriginal Service', 3, 'The Aboriginal Service provides outpatient groups and individual counselling to Aboriginal people experiencing substance use and other mental health challenges.',
'People who self-identify as First Nations, Inuit or Métis.', '416-535-8501 press 2', 'N/A', 'Community', 'The treatment team includes Aboriginal Social Workers and an Elder/Traditional healer, as well as access to psychiatry.', 
'https://www.camh.ca/en/your-care/programs-and-services/aboriginal-substance-use-outpatient--counselling-service');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Problem Gambling and Technology Use Treatment Services', 3, 'This service offers support for people whose gambling or technology use is problematic, leading to difficulties in other parts of their lives.',
'Anyone who wants to quit or reduce their gambling or technology use.', '416-535-8501 press 2', 'N/A', 'Addiction', 'Problem Gambling and Technology Treatment Groups', 
'https://www.camh.ca/en/your-care/programs-and-services/problem-gambling--technology-use-treatment');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Rainbow Services (2SLGBTQ+)', 3, 'Group therapy is provided to lesbian, gay, bisexual, transgender, queer and two-spirit people who are concerned about their drug and alcohol use.',
'Lesbian, gay, bisexual, transgender, queer and two-spirit people who are concerned about their drug and alcohol use.', '416-535-8501 press 2', 'N/A', 'Community', 'Our services are confidential and covered by OHIP. In-town and out-of-town clients are all welcome.', 
'https://www.camh.ca/en/your-care/programs-and-services/rainbow-services-2slgbtq');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Mood & Anxiety Service for Children & Youth', 4, 'The Mood and Anxiety Service offers assessment and treatment for children and youth aged 6-18 years old (and their parents/caregivers) who are experiencing mood and/or anxiety difficulties. Children and young people seen in the service are typically experiencing problems related to worry, phobias, emotions, sadness and/or hopelessness.',
'Children and youth aged 6-18 years (and their parents/caregivers) who are experiencing mood and/or anxiety difficulties.', '416-535-8501 press 2', 'N/A', 'Youth', 'Psychological education groups are also offered to parents/caregivers wanting to better understand mood and anxiety difficulties in children and youth and to better support and advocate for their children.', 
'https://www.camh.ca/en/your-care/programs-and-services/mood-anxiety-for-children-youth-service');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Late-Life Mood Disorder Clinic', 4, 'This clinic provides psychiatric consultation for patients age 65 and older with long-standing or recently emergent mood disorders.',
'Patients age 65 and older with long-standing or recently emergent mood disorders.', '416 535-8501 ext. 33448', 'N/A', 'Senior', 'The clinic primarily provides consultation services and ongoing treatment through clinical research programs.', 
'https://www.camh.ca/en/your-care/programs-and-services/latelife-mood-disorder-clinic');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('General Geriatrics Clinic', 4, 'This clinic offers psychiatric consultation and follow-up services for adults age 65 and older with longstanding or recently emergent mental illness, including schizophrenia, psychotic disorders., trauma, or other forms of persistent mental illness. Treatment plans take into consideration the multiple medical challenges often associated with aging.',
'Adults age 65 and older with long-standing or recently emergent schizophrenia or psychotic disorders.', '416 535-8501 ext. 33448', 'N/A', 'Senior', 'A weekly one hour group where clients can meet for social connection, conversation and cognitive stimulation.', 
'https://www.camh.ca/en/your-care/programs-and-services/general-geriatrics-clinic');
INSERT INTO Resources 
(resource_title, location_id, description, intended_clients, phone, email, service_type, treatment_type, link) 
VALUES ('Downtown Clinics', 5, 'This service provides coordinated and comprehensive treatment for people who have chronic schizophrenia or related disorders and live in the community.',
'Individuals with chronic schizophrenia or related disorders, with or without substance use, who are living in the community within the catchment areas.', '416 535-8501 press 2', 'N/A', 'Mental Health', 'The approach is recovery-oriented, interdisciplinary, and holistic. Assessment; individual, family and group counselling; medication monitoring; case management; and peer support and education are also provided.', 
'https://www.camh.ca/en/your-care/programs-and-services/downtown-clinics');
