# Changelog for WindowAbstractions.jl

## Version `v0.6`

- ![BREAKING][badge-breaking] ![Feature][badge-feature] The callback-based API has been replaced by an event queue-based API. Instead of providing a high-level interface for callbacks (which execute when events of a certain kind have been detected), it provides you with events which you can pull from a queue so that you have full control over how events are handled, and when to poll for new events.
- `set_extent` has been renamed `resize`.
- ![BREAKING][badge-breaking] `EventDetails` has been removed in favor of an `Event` type, which possesses an `EventType` enum which indicates the type of event; previously, this information was encoded in the type of the event data, largely resulting in type instabilities.
- ![BREAKING][badge-breaking] `KeyModifierState` has been removed in favor of a `ModifierState` integer bitmask to make masking operations easier.
- ![BREAKING][badge-breaking] `KeyContext` has been removed and its data moved over to `ModifierState` values (capslock and mod2 for numlock).
- ![BREAKING][badge-breaking] `KeyCombination` has been modified to scope which modifiers to match on a lookup.

[badge-breaking]: https://img.shields.io/badge/BREAKING-red.svg
[badge-deprecation]: https://img.shields.io/badge/deprecation-orange.svg
[badge-feature]: https://img.shields.io/badge/feature-green.svg
[badge-enhancement]: https://img.shields.io/badge/enhancement-blue.svg
[badge-bugfix]: https://img.shields.io/badge/bugfix-purple.svg
[badge-security]: https://img.shields.io/badge/security-black.svg
[badge-experimental]: https://img.shields.io/badge/experimental-lightgrey.svg
[badge-maintenance]: https://img.shields.io/badge/maintenance-gray.svg

<!--
# Badges (reused from the CHANGELOG.md of Documenter.jl)

![BREAKING][badge-breaking]
![Deprecation][badge-deprecation]
![Feature][badge-feature]
![Enhancement][badge-enhancement]
![Bugfix][badge-bugfix]
![Security][badge-security]
![Experimental][badge-experimental]
![Maintenance][badge-maintenance]
-->
