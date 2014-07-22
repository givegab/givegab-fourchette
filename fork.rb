class Fourchette::Fork
  include Fourchette::Logger

  def create
    ensure_fork_created
    deploy_app
  end

  def update
    ensure_fork_created
    deploy_app
  end

  def delete
    ensure_fork_deleted
  end

  def deploy_app
    tarball = Fourchette::Tarball.new
    tarball_url = tarball.url(github_git_url, git_branch_name, ENV['FOURCHETTE_GITHUB_PROJECT'])
    deploy_tarball(tarball_url)
    @github.comment_pr(pr_number, 'Deploying QA Env')
  end

  def deploy_tarball(tarball_url)
    options = { source_blob: { url: tarball_url } }
    build = @heroku.client.build.create(fork_name, options)
    monitor_build(build)
  end

  def ensure_fork_created
    unless @heroku.app_exists?(fork_name)
      @heroku.fork(ENV['FOURCHETTE_HEROKU_APP_TO_FORK'] ,fork_name)
      deploy_tarball("#{ENV['FOURCHETTE_APP_URL']}/placeholder")
      @github.comment_pr(pr_number, "Creating QA Env: #{@heroku.client.app.info(fork_name)['web_url']}")
    end
  end

  def ensure_fork_deleted
    @heroku.delete(fork_name) if @heroku.app_exists?(fork_name)
    @github.comment_pr(pr_number, 'Deleting QA Env')
  end

  private

  def git_branch_name
    "remotes/origin/#{branch_name}"
  end

  def github_git_url
    @params['pull_request']['head']['repo']['clone_url'].gsub("//github.com", "//#{ENV['FOURCHETTE_GITHUB_USERNAME']}:#{ENV['FOURCHETTE_GITHUB_PERSONAL_TOKEN']}@github.com")
  end

end
