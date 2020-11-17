FROM postgres:13

RUN apt-get update \
	&& apt-get install -y postgresql-13-plr \
	&& apt-get install -y r-cran-colorspace r-cran-ggplot2 r-cran-rcpp r-cran-magrittr \
	                      r-cran-lmtest r-cran-nnet r-cran-tseries r-cran-zoo r-cran-timedate \
	                      r-cran-urca r-cran-rcpparmadillo \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "install.packages('forecast')" | R --no-save