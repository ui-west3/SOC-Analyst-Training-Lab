(function () {
    'use strict';

    var grid = document.getElementById('museum-grid');
    var filtersWrap = document.getElementById('museum-filters');
    var modal = document.getElementById('cert-modal');
    var modalIssuer = document.getElementById('cert-modal-issuer');
    var modalTitle = document.getElementById('cert-modal-title');
    var modalDate = document.getElementById('cert-modal-date');
    var modalDesc = document.getElementById('cert-modal-desc');
    var modalCredential = document.getElementById('cert-modal-credential');
    var modalImage = document.getElementById('cert-modal-image');
    var modalImageLink = document.getElementById('cert-modal-image-link');

    if (!grid) return;

    fetch('data/certifications.json')
        .then(function (r) { return r.json(); })
        .then(function (certs) {
            render(certs, 'all');
            setupFilters(certs);
        })
        .catch(function () {
            grid.innerHTML = '<p class="section-desc">Could not load certifications data.</p>';
        });

    function setupFilters(certs) {
        if (!filtersWrap) return;
        filtersWrap.querySelectorAll('.museum-filter').forEach(function (btn) {
            btn.addEventListener('click', function () {
                filtersWrap.querySelectorAll('.museum-filter').forEach(function (b) {
                    b.classList.remove('active');
                });
                btn.classList.add('active');
                render(certs, btn.dataset.filter || 'all');
            });
        });
    }

    function render(certs, filter) {
        grid.innerHTML = '';
        var shown = certs
            .filter(function (c) {
                if (filter === 'all') return true;
                return (c.status || '').toLowerCase() === filter;
            });

        shown.forEach(function (c, index) {
                var status = (c.status || 'planned').toLowerCase();
                var featured = !!c.featured;
                var card = document.createElement('article');
                card.className = featured ? 'museum-card featured reveal' : 'museum-card reveal';
                card.style.animationDelay = (index * 90) + 'ms';
                var chips = [];
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
                }
                card.innerHTML =
                    imageBlock +
                    '<div class="museum-card-body">' +
                    '<div class="museum-card-top">' +
                        '<span class="museum-issuer">' + escapeHtml(c.issuer || 'Issuer') + '</span>' +
                        '<span class="museum-status ' + escapeHtml(status) + '">' + (featured ? 'Featured' : escapeHtml(statusLabel(status))) + '</span>' +
                    '</div>' +
                    (featured ? '<p class="museum-kicker">Flagship SOC path</p>' : '') +
                    '<h3 class="museum-title">' + escapeHtml(c.title || 'Untitled') + '</h3>' +
                    '<p class="museum-date">' + escapeHtml(c.date || 'TBD') + '</p>' +
                    (chips.length ? '<div class="museum-chips">' + chips.join('') + '</div>' : '') +
                    '<p class="museum-desc">' + escapeHtml(c.description || '') + '</p>' +
                    '<div class="museum-actions">' +
                        '<a class="museum-link" href="' + escapeHtml(c.credential_url || '#') + '" target="_blank" rel="noopener noreferrer">View Credential</a>' +
                        '<button class="museum-open" type="button">Museum View</button>' +
                    '</div>' +
                    '</div>';

                attachSpotlight(card);
                var openBtn = card.querySelector('.museum-open');
                if (openBtn) {
                    openBtn.addEventListener('click', function () {
                        openModal(c);
                    });
                }
                grid.appendChild(card);
            });

        addPlaceholders(filter, shown.length);
    }

    function addPlaceholders(filter, currentCount) {
        var placeholderCount = getPlaceholderCount(filter);
        for (var i = 0; i < placeholderCount; i++) {
            var idx = currentCount + i;
            var card = document.createElement('article');
            card.className = 'museum-card placeholder reveal';
            card.style.animationDelay = (idx * 90) + 'ms';
            card.innerHTML =
                '<div class="museum-card-top">' +
                    '<span class="museum-issuer">TryHackMe</span>' +
                    '<span class="museum-status planned">Planned</span>' +
                '</div>' +
                '<h3 class="museum-title">Upcoming Certification</h3>' +
                '<p class="museum-date">Coming soon</p>' +
                '<p class="museum-desc">New milestone is in progress. This slot will be replaced after completion.</p>' +
                '<span class="museum-coming">Coming Soon</span>' +
                '<div class="museum-actions">' +
                    '<a class="museum-link" href="#">Hidden until earned</a>' +
                    '<button class="museum-open" type="button" disabled>Locked</button>' +
                '</div>';
            grid.appendChild(card);
        }
    }

    function getPlaceholderCount(filter) {
        if (filter === 'earned') return 1;
        if (filter === 'progress') return 2;
        if (filter === 'planned') return 3;
        return 2;
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
        modalCredential.href = cert.credential_url || '#';
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
