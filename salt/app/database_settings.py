DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '{{ pillar["db_slave"] }}',
        'USER': 'root',
        'PASSWORD': '',
        'HOST': 'localhost',
        'PORT': '',
        'TEST_CHARSET': 'UTF8',
        'TEST_NAME': 'test_satellite',
    },
}
