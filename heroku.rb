class Fourchette::Heroku
  def copy_pg from, to
    from_addons = client.addon.list(from)
    pg_enabled = from_addons.any?{ |addon| addon['name'] == 'heroku-postgresql' }
    if (pg_enabled)
      logger.info "Copying Postgres's data from #{from} to #{to}"
      backup = Fourchette::Pgbackups.new
      backup.copy(from, to)
    else
      logger.info "Postgres not enabled on #{from}. Skipping data copy."
    end
  end
end
