DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '{{ pillar["db"]["slave"]["name"] }}',
        'USER': '{{ pillar["db"]["slave"]["user"] }}',
        'PASSWORD': '{{ pillar["db"]["slave"]["password"] }}',
        'HOST': '{{ pillar["db"]["slave"]["host"] }}',
        'PORT': '{{ pillar["db"]["slave"]["port"] }}',
        'TEST_CHARSET': 'UTF8',
        'TEST_NAME': 'test_satellite',
    },
}
