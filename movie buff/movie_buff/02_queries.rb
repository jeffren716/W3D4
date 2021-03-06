def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between
  # 3 and 5 (inclusive).
  # Show the id, title, year, and score.
  Movie.select(:id,:title,:yr,:score)
       .where(yr: (1980..1989), score: (3..5))
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.
  Movie.select(:yr)
       .where.not('yr IN (SELECT DISTINCT yr FROM movies WHERE score >= 8)')
       .distinct
       .pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  Casting.joins(:movie, :actor)
         .select('actors.id, actors.name')
         .where(movies: {title: title})
         .order(:ord)
end

def vanity_projects
  # List the title of all movies in which the director also appeared
  # as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.
  Casting.select("movies.id, movies.title, actors.name")
       .joins(:movie,:actor)
       .where("movies.director_id = actors.id")
       .where(ord: 1)
       .distinct
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name and number of supporting roles.
  Casting.select("actors.id, actors.name, count(*) AS roles")
         .joins(:actor)
         .where.not(ord: 1)
         .group("actors.id, actors.name")
         .order("count(*) DESC")
         .limit(2)
end
