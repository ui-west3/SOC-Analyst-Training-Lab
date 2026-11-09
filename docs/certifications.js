(function () {
    'use strict';

    var grid = document.getElementById('museum-grid');
    var stats = document.getElementById('museum-stats');
    var filtersWrap = document.getElementById('museum-filters');
    var collectionsWrap = document.getElementById('museum-collections');
    var modal = document.getElementById('cert-modal');
    var modalIssuer = document.getElementById('cert-modal-issuer');
    var modalTitle = document.getElementById('cert-modal-title');
    var modalDate = document.getElementById('cert-modal-date');
    var modalDesc = document.getElementById('cert-modal-desc');
    var modalCredential = document.getElementById('cert-modal-credential');
    var modalImage = document.getElementById('cert-modal-image');
    var modalImageLink = document.getElementById('cert-modal-image-link');

    if (!grid) return;

    var state = { collection: 'featured', status: 'all' };

    fetch('data/certifications.json')
        .then(function (r) { return r.json(); })
        .then(function (certs) {
            paintStats(certs);
            render(certs);
            setupFilters(certs);
        })
        .catch(function () {
            grid.innerHTML = '<p class="section-desc">Could not load certifications data.</p>';
        });

    function paintStats(certs) {
        if (!stats) return;
        var earned = certs.filter(function (c) { return (c.status || '') === 'earned'; }).length;
        var progress = certs.filter(function (c) { return (c.status || '') === 'progress'; }).length;
        var planned = certs.filter(function (c) { return (c.status || '') === 'planned'; }).length;
        stats.innerHTML =
            '<div class="museum-stat"><strong>' + earned + '</strong><span>Earned</span></div>' +
            '<div class="museum-stat"><strong>' + progress + '</strong><span>In progress</span></div>' +
            '<div class="museum-stat"><strong>' + planned + '</strong><span>Planned</span></div>' +
            '<div class="museum-stat"><strong>' + certs.length + '</strong><span>On shelf</span></div>';
    }

    function setupFilters(certs) {
        bindGroup(collectionsWrap, 'collection', 'data-collection', function (value) {
            state.collection = value;
            render(certs);
        });
        bindGroup(filtersWrap, 'status', 'data-filter', function (value) {
            state.status = value;
            render(certs);
        });
    }

    function bindGroup(wrap, _kind, attr, onChange) {
        if (!wrap) return;
        wrap.querySelectorAll('.museum-filter').forEach(function (btn) {
            btn.addEventListener('click', function () {
                wrap.querySelectorAll('.museum-filter').forEach(function (b) {
                    b.classList.remove('active');
                });
                btn.classList.add('active');
                onChange(btn.getAttribute(attr) || 'all');
            });
        });
    }

    function matches(cert) {
        var status = (cert.status || 'planned').toLowerCase();
        var collection = (cert.collection || 'vendors').toLowerCase();

        if (state.status !== 'all' && status !== state.status) return false;

        if (state.collection === 'all') return true;
        if (state.collection === 'featured') return !!cert.featured;
        return collection === state.collection;
    }

    function sortCerts(list) {
        var rank = { progress: 1, earned: 0, planned: 2 };
        return list.slice().sort(function (a, b) {
            if (!!b.featured - !!a.featured) return !!b.featured - !!a.featured;
            var sa = rank[(a.status || '').toLowerCase()] || 9;
            var sb = rank[(b.status || '').toLowerCase()] || 9;
            if (sa !== sb) return sa - sb;
            return String(b.date || '').localeCompare(String(a.date || ''));
        });
    }

    function render(certs) {
        grid.innerHTML = '';
        var shown = sortCerts(certs.filter(matches));

        if (!shown.length) {
            grid.innerHTML =
                '<p class="museum-empty">Nothing in this shelf yet — switch collection or status, or finish the next course.</p>';
            return;
        }

        shown.forEach(function (c, index) {
            var status = (c.status || 'planned').toLowerCase();
            var featured = !!c.featured;
            var card = document.createElement('article');
            card.className = featured ? 'museum-card featured reveal' : 'museum-card reveal';
            if (status === 'progress') card.classList.add('in-progress');
            card.style.animationDelay = (index * 90) + 'ms';

            var chips = [];
            if (c.collection) {
                chips.push('<span class="museum-chip museum-chip-collection">' + escapeHtml(collectionLabel(c.collection)) + '</span>');
            }
            if (c.hours) {
                chips.push('<span class="museum-chip">' + escapeHtml(c.hours) + '</span>');
            }
            if (c.credential_id) {
                chips.push('<span class="museum-chip museum-chip-id">' + escapeHtml(c.credential_id) + '</span>');
            }
            if (c.badge) {
                card.classList.add('has-badge');
            }

            var imageBlock = '';
            if (c.image) {
                imageBlock =
                    '<div class="museum-image-wrap' + (c.badge ? ' with-badge' : '') + '">' +
                    '<img class="museum-image" src="' + escapeHtml(c.image) + '" alt="' + escapeHtml((c.title || 'Certificate') + ' preview') + '" loading="lazy">' +
                    (c.badge
                        ? '<img class="museum-badge-float" src="' + escapeHtml(c.badge) + '" alt="' + escapeHtml((c.title || '') + ' badge') + '" loading="lazy">'
                        : '') +
                    '</div>';
            } else if (c.badge) {
                imageBlock =
                    '<div class="museum-badge-solo">' +
                    '<img src="' + escapeHtml(c.badge) + '" alt="' + escapeHtml((c.title || '') + ' badge') + '" loading="lazy">' +
                    '</div>';
            } else if (status === 'progress') {
                imageBlock =
                    '<div class="museum-progress-panel">' +
                    '<span class="museum-progress-tag">Now studying</span>' +
                    '<p>Progress slot — will unlock the certificate image after completion.</p>' +
                    '</div>';
            }

            var statusText = featured ? 'Featured' : statusLabel(status);
            var credentialHref = c.credential_url || '#';
            var hasCredential = !!(c.credential_url && c.credential_url !== '#');

            card.innerHTML =
                imageBlock +
                '<div class="museum-card-body">' +
                '<div class="museum-card-top">' +
                    '<span class="museum-issuer">' + escapeHtml(c.issuer || 'Issuer') + '</span>' +
                    '<span class="museum-status ' + escapeHtml(status) + '">' + escapeHtml(statusText) + '</span>' +
                '</div>' +
                (featured ? '<p class="museum-kicker">Flagship SOC path</p>' : '') +
                '<h3 class="museum-title">' + escapeHtml(c.title || 'Untitled') + '</h3>' +
                '<p class="museum-date">' + escapeHtml(c.date || 'TBD') + '</p>' +
                (chips.length ? '<div class="museum-chips">' + chips.join('') + '</div>' : '') +
                '<p class="museum-desc">' + escapeHtml(c.description || '') + '</p>' +
                '<div class="museum-actions">' +
                    (hasCredential
                        ? '<a class="museum-link" href="' + escapeHtml(credentialHref) + '" target="_blank" rel="noopener noreferrer">View Credential</a>'
                        : '<span class="museum-link muted">Credential pending</span>') +
                    '<button class="museum-open" type="button"' + (c.image || c.description ? '' : ' disabled') + '>Museum View</button>' +
                '</div>' +
                '</div>';

            attachSpotlight(card);
            var openBtn = card.querySelector('.museum-open');
            if (openBtn && !openBtn.disabled) {
                openBtn.addEventListener('click', function () {
                    openModal(c);
                });
            }
            grid.appendChild(card);
        });
    }

    function openModal(cert) {
        if (!modal) return;
        if (modalImage) {
            if (cert.image) {
                modalImage.src = cert.image;
                modalImage.alt = (cert.title || 'Certificate') + ' preview';
                modalImage.hidden = false;
                if (modalImageLink) {
                    modalImageLink.href = cert.image;
                    modalImageLink.hidden = false;
                }
            } else {
                modalImage.hidden = true;
                modalImage.src = '';
                modalImage.alt = 'Certificate preview';
                if (modalImageLink) {
                    modalImageLink.hidden = true;
                    modalImageLink.href = '#';
                }
            }
        }
        modalIssuer.textContent = cert.issuer || '';
        modalTitle.textContent = cert.title || '';
        var dateLine = cert.date || '';
        if (cert.credential_id) {
            dateLine = dateLine ? dateLine + ' · ' + cert.credential_id : cert.credential_id;
        }
        if (cert.hours) {
            dateLine = dateLine ? dateLine + ' · ' + cert.hours : cert.hours;
        }
        modalDate.textContent = dateLine;
        modalDesc.textContent = cert.description || '';
        if (cert.credential_url) {
            modalCredential.href = cert.credential_url;
            modalCredential.style.display = '';
        } else {
            modalCredential.removeAttribute('href');
            modalCredential.style.display = 'none';
        }
        modal.classList.add('show');
        modal.setAttribute('aria-hidden', 'false');
    }

    function closeModal() {
        if (!modal) return;
        modal.classList.remove('show');
        modal.setAttribute('aria-hidden', 'true');
    }

    if (modal) {
        modal.querySelectorAll('[data-close-modal="true"]').forEach(function (el) {
            el.addEventListener('click', closeModal);
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') closeModal();
        });
    }

    function statusLabel(status) {
        if (status === 'earned') return 'Earned';
        if (status === 'progress') return 'In Progress';
        return 'Planned';
    }

    function collectionLabel(collection) {
        if (collection === 'platforms') return 'Labs & paths';
        if (collection === 'vendors') return 'Vendors';
        return collection;
    }

    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function attachSpotlight(el) {
        var rafId = null;
        var x = 0;
        var y = 0;
        el.addEventListener('mousemove', function (e) {
            var rect = el.getBoundingClientRect();
            x = e.clientX - rect.left;
            y = e.clientY - rect.top;
            if (rafId) return;
            rafId = requestAnimationFrame(function () {
                el.style.setProperty('--mx', x + 'px');
                el.style.setProperty('--my', y + 'px');
                rafId = null;
            });
        });
    }
})();
