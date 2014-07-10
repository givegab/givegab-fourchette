class Fourchette::Heroku
  def copy_pg from, to
    if pg_enabled?(from)
      logger.info "Copying Postgres's data from #{from} to #{to}"
      backup = Fourchette::Pgbackups.new
      backup.copy(from, to)
    else
      logger.info "Postgres not enabled on #{from}. Skipping data copy."
    end
  end

  def pg_enabled?(app)
    client.addon.list(app).any?{ |addon| addon['addon_service']['name'] == 'heroku-postgresql' }
  end
end
