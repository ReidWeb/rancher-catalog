version: '2'

services:

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.3
    volumes:
      - /data/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:ro
    ports:
      - "9200:9200"
      - "9300:9300"
    environment:
      ES_JAVA_OPTS: "-Xmx256m -Xms256m"
    networks:
      - elk

  logstash:
    image: docker.elastic.co/logstash/logstash-oss:6.2.3
    volumes:
      - /data/logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro
      - /data/logstash/pipeline:/usr/share/logstash/pipeline:ro
    ports:
      - "5000:5000"
    environment:
      LS_JAVA_OPTS: "-Xmx256m -Xms256m"
    networks:
      - elk
    depends_on:
      - elasticsearch

  kibana:
    image:  docker.elastic.co/kibana/kibana-oss:6.2.3
    volumes:
      - /data/kibana/config/:/usr/share/kibana/config:ro
    ports:
      - "5601:5601"
    networks:
      - elk
    depends_on:
      - elasticsearch

networks:

  elk:
    driver: bridge