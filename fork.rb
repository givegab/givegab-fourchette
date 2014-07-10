class Fourchette::Fork
  include Fourchette::Logger

  def update
    create_unless_exists
    tarball = Fourchette::Tarball.new
    tarball_url = tarball.url(github_git_url, git_branch_name, ENV['FOURCHETTE_GITHUB_PROJECT'])
    logger.info "Created Tarball: #{tarball_url}"
    logger.info 'Skipping Build of Tarball'
  end

end
