import { useState, useMemo, useRef, useEffect } from "react";
import { Icon } from "./Icon";

export interface ModelOption {
  value: string;
  label: string;
  description?: string;
  provider: string;
  contextWindow?: number;
  isFreeTier?: boolean;
}

interface Props {
  value: string;
  options: ModelOption[];
  onChange: (value: string) => void;
  align?: "left" | "right";
  className?: string;
  placeholder?: string;
}

const PROVIDER_ORDER = [
  "llm7",
  "gemini",
  "groq",
  "openai",
  "anthropic",
  "mistral",
  "cohere",
  "ollama",
  "sambanova",
  "huggingface",
  "openrouter",
  "cerebras",
  "nvidia",
  "xai",
  "deepseek",
  "perplexity",
];

function getProviderDisplayName(provider: string): string {
  const displayNames: Record<string, string> = {
    llm7: "LLM7 (Free)",
    gemini: "Google Gemini",
    groq: "Groq",
    openai: "OpenAI",
    anthropic: "Anthropic",
    mistral: "Mistral",
    cohere: "Cohere",
    ollama: "Ollama (Local)",
    sambanova: "SambaNova",
    huggingface: "Hugging Face",
    openrouter: "OpenRouter",
    cerebras: "Cerebras",
    nvidia: "NVIDIA",
    xai: "xAI (Grok)",
    deepseek: "DeepSeek",
    perplexity: "Perplexity",
  };
  return displayNames[provider] || provider;
}

function getContextWindowLabel(ctx?: number): string {
  if (!ctx) return "";
  if (ctx >= 1000000) return `${(ctx / 1000000).toFixed(1)}M ctx`;
  if (ctx >= 1000) return `${(ctx / 1000).toFixed(0)}K ctx`;
  return `${ctx} ctx`;
}

export function GroupedModelDropdown({
  value,
  options,
  onChange,
  align = "left",
  className = "",
  placeholder = "Select model…",
}: Props) {
  const [open, setOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [expandedProviders, setExpandedProviders] = useState<Set<string>>(new Set());
  const menuRef = useRef<HTMLDivElement>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);

  const current = options.find((o) => o.value === value);

  const groupedOptions = useMemo(() => {
    const filtered = options.filter((opt) =>
      opt.label.toLowerCase().includes(searchQuery.toLowerCase()) ||
      opt.provider.toLowerCase().includes(searchQuery.toLowerCase()) ||
      opt.value.toLowerCase().includes(searchQuery.toLowerCase())
    );

    const groups: Record<string, ModelOption[]> = {};
    filtered.forEach((opt) => {
      const provider = opt.provider;
      if (!groups[provider]) groups[provider] = [];
      groups[provider].push(opt);
    });

    const sortedProviders = Object.keys(groups).sort((a, b) => {
      const aIndex = PROVIDER_ORDER.indexOf(a);
      const bIndex = PROVIDER_ORDER.indexOf(b);
      if (aIndex !== -1 && bIndex !== -1) return aIndex - bIndex;
      if (aIndex !== -1) return -1;
      if (bIndex !== -1) return 1;
      return a.localeCompare(b);
    });

    return sortedProviders.map((provider) => ({
      provider,
      displayName: getProviderDisplayName(provider),
      models: groups[provider],
      expanded: expandedProviders.has(provider),
    }));
  }, [options, searchQuery, expandedProviders]);

  const toggleProvider = (provider: string) => {
    setExpandedProviders((prev) => {
      const next = new Set(prev);
      if (next.has(provider)) next.delete(provider);
      else next.add(provider);
      return next;
    });
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Escape") {
      setOpen(false);
      setSearchQuery("");
    }
  };

  useEffect(() => {
    if (open) {
      searchInputRef.current?.focus();
      const handler = (e: KeyboardEvent) => {
        if (e.key === "Escape") {
          setOpen(false);
          setSearchQuery("");
        }
      };
      document.addEventListener("keydown", handler);
      return () => document.removeEventListener("keydown", handler);
    }
  }, [open]);

  return (
    <div className="dd">
      <button
        className={"pill" + (className ? " " + className : "")}
        onClick={() => setOpen((v) => !v)}
        title={current?.label || value}
      >
        <span className="pill-label">
          {current?.label || placeholder}
        </span>
        <Icon name="chevronDown" size={13} className="caret" />
      </button>

      {open && (
        <>
          <div className="dd-backdrop" onClick={() => { setOpen(false); setSearchQuery(""); }} />
          <div className={"dd-menu " + align} ref={menuRef} role="menu">
            <div className="dd-search">
              <Icon name="search" size={14} className="search-icon" />
              <input
                ref={searchInputRef}
                type="text"
                placeholder="Search models…"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                onKeyDown={handleKeyDown}
                className="search-input"
              />
            </div>
            <div className="dd-groups" role="listbox">
              {groupedOptions.length === 0 ? (
                <div className="dd-empty">No models match "{searchQuery}"</div>
              ) : (
                groupedOptions.map((group) => (
                  <div key={group.provider} className="dd-provider-group">
                    <button
                      type="button"
                      className="dd-provider-header"
                      onClick={() => toggleProvider(group.provider)}
                    >
                      <span className="dd-provider-name">{group.displayName}</span>
                      <span className="dd-provider-count">{group.models.length} models</span>
                      <Icon
                        name={group.expanded ? "chevronUp" : "chevronDown"}
                        size={12}
                        className="dd-provider-toggle"
                      />
                    </button>
                    {group.expanded && (
                      <div className="dd-provider-models" role="group">
                        {group.models.map((model) => (
                          <div
                            key={model.value}
                            className={"dd-item" + (model.value === value ? " sel" : "")}
                            role="option"
                            aria-selected={model.value === value}
                            onClick={() => {
                              onChange(model.value);
                              setOpen(false);
                              setSearchQuery("");
                            }}
                          >
                            <div className="dd-label-row">
                              <span className="dd-label">{model.label}</span>
                              {model.value === value && <span className="chk">✓</span>}
                            </div>
                            <div className="dd-meta">
                              {model.description && <span className="dd-desc">{model.description}</span>}
                              {model.contextWindow && (
                                <span className="dd-ctx">{getContextWindowLabel(model.contextWindow)}</span>
                              )}
                              {model.isFreeTier && <span className="dd-free-badge">Free</span>}
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                ))
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );
}