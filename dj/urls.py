from django.conf import settings
from django.conf.urls import patterns, include, url
from django.conf.urls.static import static
from django.views.generic.simple import direct_to_template

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    url(r"^$", direct_to_template, {"template": "homepage.html"}, name="home"),
    url(r'^polls/', include('polls.urls')),
    url(r'^admin/', include(admin.site.urls)),
    url(r"^mu-4b9a3550-85944871-f8b6aaf5-0ea7cfde$", direct_to_template, {"template": "42.html"}),
)