FROM php:5.6-cli
EXPOSE 8080
COPY artifacts/hitcounter.phar .
RUN echo '<?php require("hitcounter.phar");' > router.php
CMD php -S 0.0.0.0:8080 router.php
