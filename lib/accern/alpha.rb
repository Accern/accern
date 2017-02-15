module Accern
  class Alpha
    attr_reader :token, :base_url, :uri, :last_id, :new_id, :docs,
                :format, :flat, :params

    def initialize(options)
      @token = options.fetch(:token)
      @format = options.fetch(:format, :json)
      @params = options.fetch(:params, {})
      @base_url = 'http://feed.accern.com/v3/alphas'
      @uri = URI(base_url)
      read_last_id
      @flat = Flatner.new
    end

    def download(path)
      uri.query = URI.encode_www_form(last_id: last_id) if last_id
      puts uri

      format_response(
        Net::HTTP.new(uri.host, uri.port).request_get(uri, header)
      )

      return if new_id == last_id

      save_last_id

      generate_csv_header(path) if format == :csv

      File.open(path, 'a') do |f|
        if format == :json
          docs.reverse_each { |d| f.puts d.to_json }
        end

        if format == :csv
          docs.reverse_each { |d| f.puts flat.process(d) }
        end
      end

    rescue => e
      puts e.message
      puts e.backtrace
    end

    def download_loop(path)
      loop do
        download(path)
        sleep 8
      end
    end

    private

    def header
      { 'Authorization' => %(Token token="#{token}") }
    end

    def save_last_id
      @last_id = docs.first['id']
      File.write('./alpha_last_id.yml', last_id.to_yaml)
    end

    def format_response(response)
      @docs = JSON.parse(response.body)
      @new_id = docs.first.to_h.fetch('id', last_id)
    end

    def read_last_id
      if File.exists?('./alpha_last_id.yml')
        @last_id = YAML.load_file('./alpha_last_id.yml')
      end
    end

    def generate_csv_header(path)
      unless File.exists?(path)
        File.open(path, 'a') { |f| f.puts csv_header }
      end
    end

    def csv_header
      %w(
        article_id
        story_id
        harvested_at
        entities_name_1
        entities_ticker_1
        entities_global_id_1
        entities_entity_id_1
        entities_type_1
        entities_exchange_1
        entities_sector_1
        entities_industry_1
        entities_country_1
        entities_region_1
        entities_index_1
        entities_competitors_1
        entities_name_2
        entities_ticker_2
        entities_global_id_2
        entities_entity_id_2
        entities_type_2
        entities_exchange_2
        entities_sector_2
        entities_industry_2
        entities_country_2
        entities_region_2
        entities_index_2
        entities_competitors_2
        event_groups_group_1
        event_groups_type_1
        event_groups_group_2
        event_groups_type_2
        story_sentiment
        story_saturation
        story_volume
        story_traffic
        story_shares
        first_mention
        article_type
        article_sentiment
        article_traffic
        source_id
        overall_source_rank
        event_source_rank_1
        event_source_rank_2
        author_id
        overall_author_rank
        event_author_rank_1
        event_author_rank_2
        event_impact_score_overall
        event_impact_score_entity_1
        event_impact_score_entity_2
        avg_day_sentiment_1
        avg_day_sentiment_2
        correlations_max_positive_ticker_1
        correlations_max_positive_value_1
        correlations_max_negative_ticker_1
        correlations_max_negative_value_1
        correlations_max_positive_ticker_2
        correlations_max_positive_value_2
        correlations_max_negative_ticker_2
        correlations_max_negative_value_2
        article_url
      ).join(',')
    end
  end
end
