FROM thomasrobinson/centos7-netcdff:4.5.3-c4.7.4-gcc-mpich-slurm
## Dockerfile used to create thomasrobinson/

#RUN yum -y install wget
RUN . /opt/spack/share/spack/setup-env.sh

RUN mkdir -p /app/AM4/src

RUN cd /app/AM4/src \
    && git clone -q --recursive -b 2021.01 https://github.com/NOAA-GFDL/FMS.git \
    && git clone -q --recursive -b xanadu http://gitlab.gfdl.noaa.gov/fms/atmos_phys.git \
    && git clone -q --recursive -b 2020.04 https://github.com/NOAA-GFDL/GFDL_atmos_cubed_sphere.git \
    && git clone -q --recursive -b master https://github.com/NOAA-GFDL/atmos_drivers.git \
    && git clone -q --recursive -b xanadu http://gitlab.gfdl.noaa.gov/fms/ice_sis.git \
    && git clone -q --recursive -b xanadu http://gitlab.gfdl.noaa.gov/fms/ice_param.git \
    && git clone -q --recursive -b xanadu http://gitlab.gfdl.noaa.gov/fms/land_lad2.git

RUN cd /app/AM4/src \
    && git clone -q --recursive -b master http://gitlab.gfdl.noaa.gov/fms/ocean_shared.git \
    && git clone -b dev/gfdl/2018.04.06 https://github.com/NOAA-GFDL/MOM6-examples.git mom6 \
    && pushd mom6 \
    && git checkout dev/gfdl/2018.04.06  \
    && git submodule init src/MOM6 src/SIS2 src/icebergs tools/python/MIDAS \
    && git clone --recursive https://github.com/NOAA-GFDL/MOM6.git src/MOM6 \
    && git clone             https://github.com/NOAA-GFDL/SIS2.git src/SIS2 \
    && git clone             https://github.com/NOAA-GFDL/icebergs.git src/icebergs \
    && git submodule update \
    && popd \
    && pushd mom6 \
    && ln -s /lustre/f2/pdata/gfdl/gfdl_O/datasets/ .datasets \
    && popd

RUN cd /app/AM4/src && git clone -q --recursive -b 2021.01 https://github.com/NOAA-GFDL/FMScoupler.git


RUN cd /app/AM4 \
    && git clone https://gitlab.gfdl.noaa.gov/Thomas.Robinson/am4_build.git exec && cd exec \ 
    && make \
    && cp am4_xanadu_2021.01.x /app/AM4 \
    && make distclean

ENV PATH=/app/AM4/:${PATH}

RUN chmod 777 /app/AM4/am4_xanadu_2021.01.x

