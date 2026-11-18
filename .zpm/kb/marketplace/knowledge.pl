% The manifests define which plugins are published. These paths and the rule
% below describe where to look without duplicating the list of plugins.
catalog_path(claude_code, '.claude-plugin/marketplace.json').
catalog_path(codex, '.agents/plugins/marketplace.json').

% Call with Plugin bound to a catalog identifier.
expected_skill_path(Plugin, Path) :-
    atom(Plugin),
    atomic_list_concat([Plugin, '/skills/', Plugin, '-upgrade/SKILL.md'], Path).
