Drop database if exists premier_league;

CREATE database premier_league; 	# Creación la base de datos

USE premier_league;

DROP table if exists results;
CREATE TABLE results (				# Creación tabla results
    home_team VARCHAR(50),
	away_team VARCHAR(50),
	home_goals	int,
    away_goals	int,
    result	char(3),
    season VARCHAR(50)
);

DROP table if exists stats;
CREATE TABLE stats (				# Creación tabla stats
    team VARCHAR(50),
	wins int,
    losses	int,
    goals int,
	total_yel_card int,
    total_red_card int,
    total_scoring_att int,
    ontarget_scoring_att int,	
    hit_woodwork int,
    att_hd_goal	int,
    att_pen_goal int,
    att_freekick_goal int,
    att_ibox_goal int,
    att_obox_goal int,
    goal_fastbreak int,
    total_offside int, 
    clean_sheet int,
	goals_conceded int,
    saves int,
    outfielder_block int,
    interception int,
    total_tackle int,
    last_man_tackle int,
    total_clearance int,
	head_clearance int,
    own_goals int,
    penalty_conceded int,	
    pen_goals_conceded int,
    total_pass int,
    total_through_ball int,
    total_long_balls int,
    backward_pass int,
    total_cross	int,
    corner_taken int,
    touches	int,
    big_chance_missed int,
    clearance_off_line int,
    dispossessed int,
    penalty_save int,
    total_high_claim int,
    punches int,
    season VARCHAR(50)
);

SHOW tables;						# Confirmación que se crearon 

select * from results;
select * from stats;

SHOW VARIABLES LIKE 'local_infile'; 	# Debe estar en ON
SET GLOBAL local_infile=1;	


LOAD DATA LOCAL INFILE '/Users/andrezaragozabonilla/Desktop/Mid Bootcamp PROJECT/Data/results.txt'
INTO TABLE results
FIELDS TERMINATED BY ','			# Llenado tabla results
LINES TERMINATED BY '\n';

select * from results;				# Confirmar llenado


LOAD DATA LOCAL INFILE '/Users/andrezaragozabonilla/Desktop/Mid Bootcamp PROJECT/Data/stats.txt'
INTO TABLE stats
FIELDS TERMINATED BY ','			# Llenado tabla stats
LINES TERMINATED BY '\n';

select * from stats;				# Confirmación de llenado

#---------------------------------------------------------------------------------------

# Busco ver el total de goles por equipo por temporada
select * from results;

# Total de goles en casa para la temporada 2006-2007 del ARSENAL
select  home_team,season,sum(home_goals) AS Home_goals from results		
where home_team= 'Arsenal'
and season = '2006-2007';

# Total de goles de visitante para la temporada 2006-2007 del ARSENAL
select away_team,season,sum(away_goals) AS Away_goals from results		 
where away_team= 'Arsenal'
and season = '2006-2007';

select * from stats
where team = 'Arsenal'
and season = '2006-2007';

#-----------------------------------------------------------------------------

# Goles en casa de cada equipo por cada temporada
SELECT home_team AS team, season, SUM(home_goals) AS goles_casa
FROM results
GROUP BY home_team, season;

# Goles de visita de cada equipo por cada temporada
SELECT away_team AS team, season, SUM(away_goals) AS goles_visita
FROM results
GROUP BY away_team, season;

#--------------------------------------------------------------------------------

# Goles en casa de cada equipo por cada temporada ordenados por temporada y equipo (alfabetica)
SELECT home_team AS team, season, SUM(home_goals) AS goles_casa
FROM results
GROUP BY home_team, season
order by season, home_team;

# Goles de visita de cada equipo por cada temporada ordenados por temporada y equipo (alfabetica)
SELECT away_team AS team, season, SUM(away_goals) AS goles_visita
FROM results
GROUP BY away_team, season
order by season, away_team;

#--------------------------------------------------------------------------------

# Confirmar que son las 240 filas, ordenas por temporada y orden alfabetico los equipos
select * from stats
order by season,team;

#---------------------------------------------------------------------------------

# AGREGAR LOS GOLES DE EN CASA Y DE VISITANTE A LA TABLA (using team and season)

# Primero creamos la tabla de "goles_casa" usando el query.
Drop table goles_casa;
CREATE TABLE goles_casa  
AS SELECT home_team AS team, season, SUM(home_goals) AS goles_casa
FROM results
GROUP BY home_team, season
order by season, home_team;

# Después creamos la tabla de "goles_visitanate" usando el query.
Drop tables goles_visitante;
CREATE TABLE goles_visitante
AS SELECT away_team AS team, season, SUM(away_goals) AS goles_visita
FROM results
GROUP BY away_team, season
order by season, away_team;

show tables;
select * from goles_casa;
select * from goles_visitante;
select * from stats;

#----
# Join de stats con goles en casa
SELECT *
FROM stats
JOIN goles_casa 
USING (team, season);

# Join de stats con goles de visita
select *
from stats
join goles_visitante
using (team, season);


# Con este join se agregaron ambas goles en casa y de visita
SELECT * 
FROM stats 
JOIN goles_casa on stats.team = goles_casa.team 
AND stats.season = goles_casa.season
JOIN goles_visitante on stats.team = goles_visitante.team
AND stats.season = goles_visitante.season;


