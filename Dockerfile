# Dùng Moodle official Docker image
FROM bitnami/moodle:5.1

# Set environment variables Moodle cần
ENV MOODLE_DATABASE_HOST=postgresql://moodle_db_84oa_user:oC7880MhXgGOQ3cRgMa5xVyQ4e3Jq4Sp@dpg-d3o6tebipnbc73fo2omg-a/moodle_db_84oa
ENV MOODLE_DATABASE_PORT_NUMBER=5432
ENV MOODLE_DATABASE_USER=moodle_db_84oa_user
ENV MOODLE_DATABASE_NAME=moodle_db_84oa
ENV MOODLE_DATABASE_PASSWORD=oC7880MhXgGOQ3cRgMa5xVyQ4e3Jq4Sp

# Moodle data folder
ENV MOODLE_VOLUME=/bitnami/moodledata
