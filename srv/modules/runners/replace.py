# -*- coding: utf-8 -*-
"""
Deperecated replace runner
"""


def deprecation_message():
    """ Print deprecation message """
    print("This module was moved to 'osd.remove'")


__func_alias__ = {
    'replace': 'deprecation_message',
}
