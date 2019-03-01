# frozen_string_literal: true

require 'kramdown'

module Ghrt
  class ReviewerComments
    # rubocop:disable Metrics/MethodLength
    def self.to_html(repo, pull_request, since, verbose)
      user_comments = Github.new(repo, verbose).review_comments(pull_request, since)

      # TODO: this really should be re-written using ERB or somesuch
      html = <<~HTML
        <html>
          <head>
            <title>PR #{pull_request}</title>
            <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootswatch/4.2.1/darkly/bootstrap.min.css'/>
            <script src="https://rawgit.com/google/code-prettify/master/loader/run_prettify.js?autoload=true&amp;skin=doxy&amp;lang=css"></script>
          </head>
          <body>
            <div class="container">
            <h2>#{user_comments.count} Comments#{since ? "Since #{since}" : nil}</h2>
      HTML

      user_comments.each_with_index do |comment, index|
        html += <<~HTML
          <div class="row" ondblclick="this.classList.add('collapse')">
            <div class="col-xl-12 mb-2">
              <a target="_blank" href='#{comment['html_url']}'><h3>##{index + 1} - #{comment['path']}:#{comment['original_position']}</h3></a>
              <div class="pl-3">
                <pre class="prettyprint"><code>#{normalise_diff_hunk(comment['diff_hunk'])}</code></pre>
                <div class="text-muted" style="font-size: 1.1em">#{Kramdown::Document.new(comment['body']).to_html}</div>
              </div>
            </div>
          </div>
        HTML
      end

      html += <<~HTML
            </div>
          </body>
        </html>
      HTML
    end
    # rubocop:enable Metrics/MethodLength

    # Make hunks 6 lines long and remove headers
    def self.normalise_diff_hunk(hunk)
      return hunk.lines.to_a[1..-1].join if hunk.lines.count <= 6

      hunk.lines.to_a[(hunk.lines.count - 6)..-1].join
    end
  end
end
