FROM php:5.6-cli
EXPOSE 80
COPY artifacts/hitcounter.phar .
RUN echo '<?php require("hitcounter.phar");' > router.php
CMD php -S 0.0.0.0:80 router.php
