module Accern
  class Flatner
    def process(x)
      article_id = x['article_id']
      story_id = x['story_id']
      harvested_at = x['harvested_at']
      delivered_at = x['delivered_at']

      entities_name_1 = x['entities'].first['name'].to_s.tr(',', ' ')
      entities_ticker_1 = x['entities'].first['ticker'].to_s.tr(',', ' ')

      if x['entities'].first['global_id'].nil?
        x['entities'].first['global_id'] = []
      end
      if x['entities'].first['entity_id'].nil?
        x['entities'].first['entity_id'] = []
      end

      entities_global_id_1 = x['entities'].first['global_id']
                             .join(' ').to_s.tr(',', ' ')

      entities_entity_id_1 = x['entities'].first['entity_id']
                             .join(' ').to_s.tr(',', ' ')

      entities_type_1 = x['entities'].first['type'].to_s.tr(',', ' ')
      entities_exchange_1 = x['entities'].first['exchange'].to_s.tr(',', ' ')
      entities_sector_1 = x['entities'].first['sector'].to_s.tr(',', ' ')
      entities_industry_1 = x['entities'].first['industry'].to_s.tr(',', ' ')
      entities_country_1 = x['entities'].first['country'].to_s.tr(',', ' ')
      entities_region_1 = x['entities'].first['region'].to_s.tr(',', ' ')
      entities_index_1 = x['entities'].first['index'].to_s.tr(',', ' ')
      entities_competitors_1 = x['entities'].first['competitors']
                               .to_s.tr(',', ' ')

      entities_name_2 = ''
      entities_ticker_2 = ''
      entities_global_id_2 = ''
      entities_entity_id_2 = ''
      entities_type_2 = ''
      entities_exchange_2 = ''
      entities_sector_2 = ''
      entities_industry_2 = ''
      entities_country_2 = ''
      entities_region_2 = ''
      entities_index_2 = ''
      entities_competitors_2 = ''

      if x['entities'].length > 1
        entities_name_2 = x['entities'][1]['name'].to_s.tr(',', ' ')
        entities_ticker_2 = x['entities'][1]['ticker'].to_s.tr(',', ' ')
        if x['entities'][1]['global_id'].nil?
          x['entities'][1]['global_id'] = []
        end
        if x['entities'][1]['entity_id'].nil?
          x['entities'][1]['entity_id'] = []
        end

        entities_global_id_2 = x['entities'][1]['global_id']
                               .join(' ').to_s.tr(',', ' ')

        entities_entity_id_2 = x['entities'][1]['entity_id']
                               .join(' ').to_s.tr(',', ' ')

        entities_type_2 = x['entities'][1]['type'].to_s.tr(',', ' ')
        entities_exchange_2 = x['entities'][1]['exchange'].to_s.tr(',', ' ')
        entities_sector_2 = x['entities'][1]['sector'].to_s.tr(',', ' ')
        entities_industry_2 = x['entities'][1]['industry'].to_s.tr(',', ' ')
        entities_country_2 = x['entities'][1]['country'].to_s.tr(',', ' ')
        entities_region_2 = x['entities'][1]['region'].to_s.tr(',', ' ')
        entities_index_2 = x['entities'][1]['index'].to_s.tr(',', ' ')
        entities_competitors_2 = x['entities'][1]['competitors'].to_s.tr(',', ' ')
      end

      event_groups_group_1 = x['event_groups'].first['group'].to_s.tr(',', ' ')
      event_groups_type_1 = x['event_groups'].first['type'].to_s.tr(',', ' ')
      event_groups_group_2 = ''
      event_groups_type_2 = ''

      if x['event_groups'].length > 1
        event_groups_group_2 = x['event_groups'][1]['group'].to_s.tr(',', ' ')
        event_groups_type_2 = x['event_groups'][1]['type'].to_s.tr(',', ' ')
      end

      story_sentiment = x['story_sentiment']
      story_saturation = x['story_saturation']
      story_volume = x['story_volume']
      story_traffic = x['story_traffic']
      story_shares = x['story_shares']
      first_mention = x['first_mention']
      article_type = x['article_type']
      article_sentiment = x['article_sentiment']
      article_traffic = x['article_traffic']
      article_url = x['article_url']

      if article_url.nil?
        article_url = ''
      end

      article_url = article_url.to_s.tr(',', '')

      author_id = x['author_id']
      source_id = x['source_id']

      overall_source_rank = x['overall_source_rank']
      event_source_rank_1 = ''
      if x['event_source_rank'].length > 0
        event_source_rank_1 = x['event_source_rank'].first['source_rank']
      end
      event_source_rank_2 = ''
      if x['event_source_rank'].length > 1
        event_source_rank_2 = x['event_source_rank'][1]['source_rank']
      end

      overall_author_rank = x['overall_author_rank']
      event_author_rank_1 = ''
      if x['event_author_rank'].length > 0
        event_author_rank_1 = x['event_author_rank'].first['author_rank']
      end
      event_author_rank_2 = ''
      if x['event_author_rank'].length > 1
        event_author_rank_2 = x['event_author_rank'][1]['author_rank']
      end

      event_impact_score_overall =  x['event_impact_score']['overall']
      event_impact_score_entity_1 = ''
      event_impact_score_entity_2 = ''

      event_impact_score_entity_1 = x['event_impact_score']['on_entities']
                                    .first['on_entity']

      if x['event_impact_score']['on_entities'].length > 1
        event_impact_score_entity_2 =
          x['event_impact_score']['on_entities'][1]['on_entity']
      end

      avg_day_sentiment_1 = ''
      avg_day_sentiment_2 = ''
      if x['avg_day_sentiment'].nil?
        x['avg_day_sentiment'] = []
      end
      if x['avg_day_sentiment_1'] && x['avg_day_sentiment_1'].length > 0
        avg_day_sentiment_1 = x['avg_day_sentiment_1'].first['value']
      end
      if x['avg_day_sentiment_1'] && x['avg_day_sentiment_1'].length > 1
        avg_day_sentiment_2 = x['avg_day_sentiment_1'][1]['value']
      end

      correlations_max_positive_ticker_1 = ''
      correlations_max_positive_value_1 = ''
      correlations_max_negative_ticker_1 = ''
      correlations_max_negative_value_1 = ''
      correlations_max_positive_ticker_2 = ''
      correlations_max_positive_value_2 = ''
      correlations_max_negative_ticker_2 = ''
      correlations_max_negative_value_2 = ''

      if x['correlations'].length > 0
        cors = x['correlations'].first['with_entity']
        cors.each do |c|
          if c['type'] == 'max_positive'
            correlations_max_positive_ticker_1 = c['ticker'].to_s.tr(',', ' ')
            correlations_max_positive_value_1 = c['value']
          else
            correlations_max_negative_ticker_1 = c['ticker'].to_s.tr(',', ' ')
            correlations_max_negative_value_1 = c['value']
          end
        end
      end

      if x['correlations'].length > 1
        cors = x['correlations'][1]['with_entity']
        cors.each do |c|
          if c['type'] == 'max_positive'
            correlations_max_positive_ticker_2 = c['ticker'].to_s.tr(',', ' ')
            correlations_max_positive_value_2 = c['value']
          else
            correlations_max_negative_ticker_2 = c['ticker'].to_s.tr(',', ' ')
            correlations_max_negative_value_2 = c['value']
          end
        end
      end

      [
        article_id,
        story_id,
        harvested_at,
        entities_name_1,
        entities_ticker_1,
        entities_global_id_1,
        entities_entity_id_1,
        entities_type_1,
        entities_exchange_1,
        entities_sector_1,
        entities_industry_1,
        entities_country_1,
        entities_region_1,
        entities_index_1,
        entities_competitors_1,
        entities_name_2,
        entities_ticker_2,
        entities_global_id_2,
        entities_entity_id_2,
        entities_type_2,
        entities_exchange_2,
        entities_sector_2,
        entities_industry_2,
        entities_country_2,
        entities_region_2,
        entities_index_2,
        entities_competitors_2,
        event_groups_group_1,
        event_groups_type_1,
        event_groups_group_2,
        event_groups_type_2,
        story_sentiment,
        story_saturation,
        story_volume,
        story_traffic,
        story_shares,
        first_mention,
        article_type,
        article_sentiment,
        article_traffic,
        source_id,
        overall_source_rank,
        event_source_rank_1,
        event_source_rank_2,
        author_id,
        overall_author_rank,
        event_author_rank_1,
        event_author_rank_2,
        event_impact_score_overall,
        event_impact_score_entity_1,
        event_impact_score_entity_2,
        avg_day_sentiment_1,
        avg_day_sentiment_2,
        correlations_max_positive_ticker_1,
        correlations_max_positive_value_1,
        correlations_max_negative_ticker_1,
        correlations_max_negative_value_1,
        correlations_max_positive_ticker_2,
        correlations_max_positive_value_2,
        correlations_max_negative_ticker_2,
        correlations_max_negative_value_2,
        "\"#{article_url}\""
      ].join(',')

    rescue => e
      puts e
      puts e.backtrace
    end
  end
end
